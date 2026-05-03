import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/seed_data.dart';
import '../models/team.dart';
import '../models/tournament.dart';
import '../providers/tournament_provider.dart';
import 'match_detail_screen.dart';
import 'standings_screen.dart';

const _dayNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
const _monthNames = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

String formatMatchDate(DateTime d) {
  final dn = _dayNames[d.weekday - 1];
  return '$dn ${d.day} de ${_monthNames[d.month - 1]}';
}

Team? teamFromCode(String? code) {
  if (code == null) return null;
  for (final g in kGroups) {
    for (final t in g.teams) {
      if (t.code == code) return t;
    }
  }
  return null;
}

String placeholderLabel(String placeholder) {
  if (placeholder.length == 2 &&
      (placeholder.startsWith('1') || placeholder.startsWith('2'))) {
    final pos = placeholder[0] == '1' ? '1.º' : '2.º';
    return '$pos Grupo ${placeholder.substring(1)}';
  }
  if (placeholder.startsWith('3')) {
    return 'Mejor 3.º (${placeholder.substring(1)})';
  }
  if (placeholder.startsWith('W')) {
    return 'Ganador #${placeholder.substring(1)}';
  }
  if (placeholder.startsWith('L')) {
    return 'Perdedor #${placeholder.substring(1)}';
  }
  return placeholder;
}

class MatchesScreen extends StatefulWidget {
  final String? filterTeamCode;
  const MatchesScreen({super.key, this.filterTeamCode});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  MatchPhase? _phaseFilter;

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TournamentProvider>();
    final scheme = Theme.of(context).colorScheme;
    final teamCode = widget.filterTeamCode;

    if (!tp.loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var matches = teamCode != null
        ? tp.matchesForTeam(teamCode)
        : tp.allMatches.toList();
    if (_phaseFilter != null) {
      matches = matches.where((m) => m.phase == _phaseFilter).toList();
    }

    matches.sort((a, b) {
      final cmp = a.date.compareTo(b.date);
      if (cmp != 0) return cmp;
      return a.id.compareTo(b.id);
    });

    final byDate = <DateTime, List<WorldCupMatch>>{};
    for (final m in matches) {
      final key = DateTime(m.date.year, m.date.month, m.date.day);
      byDate.putIfAbsent(key, () => []).add(m);
    }
    final orderedDates = byDate.keys.toList()..sort();

    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    return Scaffold(
      appBar: AppBar(
        title: Text(teamCode != null ? 'Partidos · $teamCode' : 'Calendario'),
        actions: [
          if (teamCode == null)
            IconButton(
              tooltip: 'Tablas de posiciones',
              icon: const Icon(Icons.leaderboard_rounded),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StandingsScreen()),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _PhaseChip(
                  label: 'Todos',
                  selected: _phaseFilter == null,
                  onTap: () => setState(() => _phaseFilter = null),
                ),
                const SizedBox(width: 8),
                for (final p in MatchPhase.values) ...[
                  _PhaseChip(
                    label: p.shortLabel,
                    selected: _phaseFilter == p,
                    onTap: () => setState(() => _phaseFilter = p),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Expanded(
            child: matches.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        teamCode != null
                            ? 'No hay partidos asignados aún para este equipo.'
                            : 'No hay partidos para este filtro.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: orderedDates.length,
                    itemBuilder: (context, i) {
                      final date = orderedDates[i];
                      final list = byDate[date]!;
                      final isToday = date == todayKey;
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DateHeader(date: date, isToday: isToday),
                            const SizedBox(height: 8),
                            for (final m in list) ...[
                              _MatchCard(match: m),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PhaseChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: selected ? scheme.onPrimary : scheme.onSurface,
      ),
      selectedColor: scheme.primary,
      backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  const _DateHeader({required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          formatMatchDate(date),
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.4,
          ),
        ),
        if (isToday) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'HOY',
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  final WorldCupMatch match;
  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final home = teamFromCode(match.resolvedHomeTeam);
    final away = teamFromCode(match.resolvedAwayTeam);
    final played = match.isPlayed;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MatchDetailScreen(matchId: match.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      match.phase == MatchPhase.group
                          ? 'Grupo ${match.groupCode}'
                          : match.phase.shortLabel,
                      style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    played ? 'Final' : 'Pendiente',
                    style: TextStyle(
                      color: played
                          ? scheme.primary
                          : scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _TeamSide(
                      team: home,
                      placeholder: match.homeTeamPlaceholder,
                      alignEnd: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _ScoreBlock(match: match),
                  ),
                  Expanded(
                    child: _TeamSide(
                      team: away,
                      placeholder: match.awayTeamPlaceholder,
                      alignEnd: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.stadium_rounded,
                      size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${match.stadium} · ${match.city}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamSide extends StatelessWidget {
  final Team? team;
  final String placeholder;
  final bool alignEnd;
  const _TeamSide({
    required this.team,
    required this.placeholder,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textAlign = alignEnd ? TextAlign.end : TextAlign.start;
    if (team == null) {
      return Column(
        crossAxisAlignment: align,
        children: [
          const Text('—', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 2),
          Text(
            placeholderLabel(placeholder),
            textAlign: textAlign,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: alignEnd
              ? [
                  Text(team!.code,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(team!.flag, style: const TextStyle(fontSize: 22)),
                ]
              : [
                  Text(team!.flag, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 6),
                  Text(team!.code,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 14)),
                ],
        ),
        const SizedBox(height: 2),
        Text(
          team!.name,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ScoreBlock extends StatelessWidget {
  final WorldCupMatch match;
  const _ScoreBlock({required this.match});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!match.isPlayed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'vs',
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.4,
          ),
        ),
      );
    }
    final hasPens =
        match.homePenalties != null && match.awayPenalties != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${match.homeScore}  -  ${match.awayScore}',
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        if (hasPens)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '(${match.homePenalties} - ${match.awayPenalties}) pen',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
