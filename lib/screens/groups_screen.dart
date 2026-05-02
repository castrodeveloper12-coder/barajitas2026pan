import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/seed_data.dart';
import '../providers/sticker_provider.dart';
import 'team_detail_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Grupos')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: kGroups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final group = kGroups[idx];
          final owned = p.groupOwned(group.code);
          final total = p.groupTotal(group.code);
          return _GroupCard(
            groupCode: group.code,
            owned: owned,
            total: total,
            teams: group.teams,
          );
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String groupCode;
  final int owned;
  final int total;
  final List<dynamic> teams;
  const _GroupCard({
    required this.groupCode,
    required this.owned,
    required this.total,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pct = total == 0 ? 0.0 : owned / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    groupCode,
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grupo $groupCode',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$owned / $total · ${(pct * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(value: pct, minHeight: 6),
            ),
            const SizedBox(height: 6),
            ...teams.map((t) => _TeamRow(team: t)),
          ],
        ),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final dynamic team;
  const _TeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    final owned = p.teamOwned(team.code);
    final total = p.teamTotal(team.code);
    final scheme = Theme.of(context).colorScheme;
    final completed = owned == total && total > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TeamDetailScreen(team: team),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Text(team.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                team.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.verified_rounded,
                  color: scheme.primary,
                  size: 18,
                ),
              ),
            Text(
              '$owned/$total',
              style: TextStyle(
                color: completed ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
