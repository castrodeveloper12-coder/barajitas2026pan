import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/seed_data.dart';
import '../models/tournament.dart';
import '../providers/tournament_provider.dart';
import 'matches_screen.dart' show teamFromCode;

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TournamentProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tablas de posiciones')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: kGroups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final g = kGroups[i];
          return _GroupTable(
            groupCode: g.code,
            standings: tp.getStandings(g.code),
            isThirdQualified: tp.qualifiedThirdGroups.contains(g.code),
          );
        },
      ),
    );
  }
}

class _GroupTable extends StatelessWidget {
  final String groupCode;
  final List<GroupStanding> standings;
  final bool isThirdQualified;
  const _GroupTable({
    required this.groupCode,
    required this.standings,
    required this.isThirdQualified,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  groupCode,
                  style: TextStyle(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Grupo $groupCode',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _HeaderRow(),
          for (var i = 0; i < standings.length; i++)
            _StandingRow(
              position: i + 1,
              standing: standings[i],
              highlight: i < 2 ||
                  (i == 2 && isThirdQualified),
            ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: scheme.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 22, child: Text('#', style: style)),
          const SizedBox(width: 8),
          Expanded(child: Text('Equipo', style: style)),
          _cell('PJ', style),
          _cell('G', style),
          _cell('E', style),
          _cell('P', style),
          _cell('GF', style),
          _cell('GC', style),
          _cell('DG', style),
          _cell('PTS', style, w: 30),
        ],
      ),
    );
  }

  Widget _cell(String t, TextStyle style, {double w = 24}) =>
      SizedBox(width: w, child: Text(t, textAlign: TextAlign.center, style: style));
}

class _StandingRow extends StatelessWidget {
  final int position;
  final GroupStanding standing;
  final bool highlight;
  const _StandingRow({
    required this.position,
    required this.standing,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final team = teamFromCode(standing.teamCode);
    final base = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    );
    final boldStyle = base.copyWith(fontWeight: FontWeight.w800);

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? scheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$position',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: highlight ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (team != null) ...[
            Text(team.flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              team?.code ?? standing.teamCode,
              style: base.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _cell('${standing.played}', base),
          _cell('${standing.won}', base),
          _cell('${standing.drawn}', base),
          _cell('${standing.lost}', base),
          _cell('${standing.goalsFor}', base),
          _cell('${standing.goalsAgainst}', base),
          _cell(
            standing.goalDifference >= 0
                ? '+${standing.goalDifference}'
                : '${standing.goalDifference}',
            base,
          ),
          _cell('${standing.points}', boldStyle, w: 30),
        ],
      ),
    );
  }

  Widget _cell(String t, TextStyle style, {double w = 24}) =>
      SizedBox(width: w, child: Text(t, textAlign: TextAlign.center, style: style));
}
