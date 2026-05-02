import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/team.dart';
import '../providers/sticker_provider.dart';
import '../widgets/counter_sheet.dart';
import '../widgets/sticker_tile.dart';

enum _TeamFilter { all, owned, missing, duplicates }

class TeamDetailScreen extends StatefulWidget {
  final Team team;
  const TeamDetailScreen({super.key, required this.team});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  _TeamFilter _filter = _TeamFilter.all;

  @override
  Widget build(BuildContext context) {
    final team = widget.team;
    final p = context.watch<StickerProvider>();
    final all = p.forTeam(team.code);
    final owned = p.teamOwned(team.code);
    final total = p.teamTotal(team.code);
    final missingCount = all.where((s) => !s.isOwned).length;
    final dupsCount = all.where((s) => s.duplicates > 0).length;
    final stickers = all.where((s) {
      switch (_filter) {
        case _TeamFilter.all:
          return true;
        case _TeamFilter.owned:
          return s.isOwned;
        case _TeamFilter.missing:
          return !s.isOwned;
        case _TeamFilter.duplicates:
          return s.duplicates > 0;
      }
    }).toList();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(team.flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 8),
            Flexible(child: Text(team.name)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grupo ${team.groupCode}',
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$owned de $total barajitas',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: total == 0 ? 0 : owned / total,
                          strokeWidth: 6,
                        ),
                        Text(
                          '${total == 0 ? 0 : ((owned / total) * 100).round()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'Todas · ${all.length}',
                  selected: _filter == _TeamFilter.all,
                  onTap: () => setState(() => _filter = _TeamFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Tengo · $owned',
                  selected: _filter == _TeamFilter.owned,
                  onTap: () => setState(() => _filter = _TeamFilter.owned),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Faltantes · $missingCount',
                  selected: _filter == _TeamFilter.missing,
                  onTap: () => setState(() => _filter = _TeamFilter.missing),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Repetidas · $dupsCount',
                  selected: _filter == _TeamFilter.duplicates,
                  onTap: () => setState(() => _filter = _TeamFilter.duplicates),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Icon(Icons.touch_app_rounded,
                    size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Toca para sumar · usa el "−" para quitar · mantén presionado para ajustar',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: stickers.isEmpty
                ? Center(
                    child: Text(
                      _filter == _TeamFilter.missing
                          ? '¡Equipo completo!'
                          : 'Nada por aquí',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: stickers.length,
                    itemBuilder: (context, i) {
                      final s = stickers[i];
                      return StickerTile(
                        sticker: s,
                        onIncrement: () => p.increment(s.id),
                        onDecrement: () => p.decrement(s.id),
                        onLongPress: () =>
                            showStickerCounterSheet(context, s.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
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
