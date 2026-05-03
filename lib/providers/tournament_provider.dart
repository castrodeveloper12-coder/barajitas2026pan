import 'package:flutter/foundation.dart';

import '../data/database.dart';
import '../data/schedule_data.dart';
import '../data/seed_data.dart';
import '../models/tournament.dart';

class TournamentProvider extends ChangeNotifier {
  final StickerDatabase _db = StickerDatabase.instance;
  final List<WorldCupMatch> _matches = buildTournamentSchedule();
  final Map<String, List<GroupStanding>> _groupStandings = {};
  final Set<String> _qualifiedThirdGroups = {};
  bool _loaded = false;

  bool get loaded => _loaded;

  List<WorldCupMatch> get allMatches => List.unmodifiable(_matches);

  List<WorldCupMatch> get groupMatches =>
      _matches.where((m) => m.phase == MatchPhase.group).toList();

  List<WorldCupMatch> get knockoutMatches =>
      _matches.where((m) => m.phase != MatchPhase.group).toList();

  List<GroupStanding> getStandings(String groupCode) =>
      _groupStandings[groupCode] ?? const [];

  Set<String> get qualifiedThirdGroups => Set.unmodifiable(_qualifiedThirdGroups);

  WorldCupMatch? matchById(int id) {
    for (final m in _matches) {
      if (m.id == id) return m;
    }
    return null;
  }

  /// Partidos en los que [teamCode] juega (solo si está resuelto).
  List<WorldCupMatch> matchesForTeam(String teamCode) {
    return _matches
        .where((m) =>
            m.resolvedHomeTeam == teamCode ||
            m.resolvedAwayTeam == teamCode)
        .toList();
  }

  TournamentProvider() {
    _initStandings();
  }

  Future<void> load() async {
    final rows = await _db.getAllMatchResults();
    for (final row in rows) {
      final id = row['match_id'] as int;
      final m = matchById(id);
      if (m == null) continue;
      m.homeScore = row['home_score'] as int?;
      m.awayScore = row['away_score'] as int?;
      m.homePenalties = row['home_pen'] as int?;
      m.awayPenalties = row['away_pen'] as int?;
    }
    _calculateGroupStandings();
    _resolveKnockoutTeams();
    _loaded = true;
    notifyListeners();
  }

  void _initStandings() {
    _groupStandings.clear();
    for (final group in kGroups) {
      _groupStandings[group.code] =
          group.teams.map((t) => GroupStanding(t.code)).toList();
    }
  }

  Future<void> updateScore(
    int matchId,
    int? home,
    int? away, {
    int? homePen,
    int? awayPen,
  }) async {
    final m = matchById(matchId);
    if (m == null) return;
    m.homeScore = home;
    m.awayScore = away;
    m.homePenalties = homePen;
    m.awayPenalties = awayPen;

    if (home != null && away != null) {
      await _db.upsertMatchResult(
        matchId: matchId,
        homeScore: home,
        awayScore: away,
        homePen: homePen,
        awayPen: awayPen,
      );
    } else {
      await _db.clearMatchResult(matchId);
    }

    _calculateGroupStandings();
    _resolveKnockoutTeams();
    notifyListeners();
  }

  Future<void> clearScore(int matchId) async {
    final m = matchById(matchId);
    if (m == null) return;
    m.homeScore = null;
    m.awayScore = null;
    m.homePenalties = null;
    m.awayPenalties = null;
    await _db.clearMatchResult(matchId);
    _calculateGroupStandings();
    _resolveKnockoutTeams();
    notifyListeners();
  }

  Future<void> resetAllResults() async {
    for (final m in _matches) {
      m.homeScore = null;
      m.awayScore = null;
      m.homePenalties = null;
      m.awayPenalties = null;
      if (m.phase != MatchPhase.group) {
        m.resolvedHomeTeam = null;
        m.resolvedAwayTeam = null;
      }
    }
    await _db.resetAllMatchResults();
    _initStandings();
    _qualifiedThirdGroups.clear();
    notifyListeners();
  }

  void _calculateGroupStandings() {
    _initStandings();

    for (final m in groupMatches.where((m) => m.isPlayed)) {
      final home = m.resolvedHomeTeam!;
      final away = m.resolvedAwayTeam!;
      final groupCode = m.groupCode!;
      final standings = _groupStandings[groupCode]!;

      final homeStand = standings.firstWhere((s) => s.teamCode == home);
      final awayStand = standings.firstWhere((s) => s.teamCode == away);

      homeStand.played++;
      awayStand.played++;
      homeStand.goalsFor += m.homeScore!;
      homeStand.goalsAgainst += m.awayScore!;
      awayStand.goalsFor += m.awayScore!;
      awayStand.goalsAgainst += m.homeScore!;

      if (m.homeScore! > m.awayScore!) {
        homeStand.won++;
        awayStand.lost++;
      } else if (m.homeScore! < m.awayScore!) {
        awayStand.won++;
        homeStand.lost++;
      } else {
        homeStand.drawn++;
        awayStand.drawn++;
      }
    }

    for (final standings in _groupStandings.values) {
      standings.sort((a, b) {
        if (a.points != b.points) return b.points.compareTo(a.points);
        if (a.goalDifference != b.goalDifference) {
          return b.goalDifference.compareTo(a.goalDifference);
        }
        return b.goalsFor.compareTo(a.goalsFor);
      });
    }
  }

  void _resolveKnockoutTeams() {
    // Reset eliminatorias
    for (final m in knockoutMatches) {
      m.resolvedHomeTeam = null;
      m.resolvedAwayTeam = null;
    }

    // Solo asignamos posiciones cuando el grupo está completo (3 partidos cada uno).
    final Map<String, String> resolvedSlots = {}; // '1A' -> 'MEX'
    final Map<String, GroupStanding> thirdsByGroup = {}; // 'A' -> 3.º

    for (final entry in _groupStandings.entries) {
      final code = entry.key;
      final st = entry.value;
      final allPlayed = st.every((s) => s.played == 3);
      if (!allPlayed) continue;

      if (st.isNotEmpty) resolvedSlots['1$code'] = st[0].teamCode;
      if (st.length > 1) resolvedSlots['2$code'] = st[1].teamCode;
      if (st.length > 2) thirdsByGroup[code] = st[2];
    }

    // Mejores 8 terceros (criterios FIFA: pts > DG > GF)
    final sortedThirds = thirdsByGroup.entries.toList()
      ..sort((a, b) {
        final sa = a.value;
        final sb = b.value;
        if (sa.points != sb.points) return sb.points.compareTo(sa.points);
        if (sa.goalDifference != sb.goalDifference) {
          return sb.goalDifference.compareTo(sa.goalDifference);
        }
        return sb.goalsFor.compareTo(sa.goalsFor);
      });
    final qualifiedGroups = sortedThirds.take(8).map((e) => e.key).toSet();
    _qualifiedThirdGroups
      ..clear()
      ..addAll(qualifiedGroups);

    // Resolver 16avos
    final usedThirdGroups = <String>{};
    String? resolveSlot(String placeholder) {
      if (resolvedSlots.containsKey(placeholder)) {
        return resolvedSlots[placeholder];
      }
      if (placeholder.startsWith('3')) {
        // ej. "3C/D/E" → primer grupo de la opción que esté clasificado y libre
        final options = placeholder.substring(1).split('/');
        for (final g in options) {
          if (usedThirdGroups.contains(g)) continue;
          if (qualifiedGroups.contains(g)) {
            usedThirdGroups.add(g);
            return thirdsByGroup[g]!.teamCode;
          }
        }
      }
      return null;
    }

    for (final m in _matches.where((m) => m.phase == MatchPhase.roundOf32)) {
      m.resolvedHomeTeam = resolveSlot(m.homeTeamPlaceholder);
      m.resolvedAwayTeam = resolveSlot(m.awayTeamPlaceholder);
    }

    // Octavos en adelante: por ganador/perdedor
    String? resolveBracket(String placeholder) {
      if (placeholder.startsWith('W')) {
        final id = int.tryParse(placeholder.substring(1));
        if (id == null) return null;
        return matchById(id)?.winner;
      }
      if (placeholder.startsWith('L')) {
        final id = int.tryParse(placeholder.substring(1));
        if (id == null) return null;
        final m = matchById(id);
        if (m == null || !m.isPlayed) return null;
        return m.winner == m.resolvedHomeTeam
            ? m.resolvedAwayTeam
            : m.resolvedHomeTeam;
      }
      return null;
    }

    for (final m in _matches.where((m) =>
        m.phase != MatchPhase.group && m.phase != MatchPhase.roundOf32)) {
      m.resolvedHomeTeam = resolveBracket(m.homeTeamPlaceholder);
      m.resolvedAwayTeam = resolveBracket(m.awayTeamPlaceholder);
    }
  }
}
