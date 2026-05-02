import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/seed_data.dart';
import '../models/team.dart';
import '../providers/sticker_provider.dart';
import 'team_detail_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  String _query = '';

  List<Team> _searchTeams() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final all = <Team>[];
    for (final g in kGroups) {
      all.addAll(g.teams);
    }
    return all
        .where((t) =>
            t.name.toLowerCase().contains(q) ||
            t.code.toLowerCase().contains(q) ||
            t.groupCode.toLowerCase() == q)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    final searching = _query.trim().isNotEmpty;
    final results = _searchTeams();

    return Scaffold(
      appBar: AppBar(title: const Text('Grupos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar país o código (BRA, ESP, A…)',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searching
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _query = ''),
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: searching
                ? _SearchResults(teams: results, provider: p)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: kGroups.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final group = kGroups[idx];
                      return _GroupCard(
                        groupCode: group.code,
                        owned: p.groupOwned(group.code),
                        total: p.groupTotal(group.code),
                        teams: group.teams,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<Team> teams;
  final StickerProvider provider;
  const _SearchResults({required this.teams, required this.provider});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (teams.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Ningún país coincide con la búsqueda',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: teams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final t = teams[i];
        final owned = provider.teamOwned(t.code);
        final total = provider.teamTotal(t.code);
        final completed = total > 0 && owned == total;
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TeamDetailScreen(team: t)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(t.flag, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Grupo ${t.groupCode} · ${t.code}',
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (completed)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child:
                          Icon(Icons.verified_rounded, color: scheme.primary),
                    ),
                  Text(
                    '$owned/$total',
                    style: TextStyle(
                      color:
                          completed ? scheme.primary : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: scheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String groupCode;
  final int owned;
  final int total;
  final List<Team> teams;
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
  final Team team;
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
