import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sticker_provider.dart';
import '../widgets/counter_sheet.dart';
import '../widgets/sticker_tile.dart';

class SpecialsScreen extends StatelessWidget {
  const SpecialsScreen({super.key});

  static const _sections = [
    ('Introducción', 'Introducción'),
    ('FIFA Museum', 'FIFA Museum'),
    ('Coca-Cola Legends', 'Coca-Cola Legends'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _sections.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Especiales'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _sections.map((s) => Tab(text: s.$1)).toList(),
          ),
        ),
        body: TabBarView(
          children: _sections.map((s) => _SectionGrid(section: s.$2)).toList(),
        ),
      ),
    );
  }
}

class _SectionGrid extends StatelessWidget {
  final String section;
  const _SectionGrid({required this.section});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    final stickers = p.bySection(section);
    final owned = stickers.where((s) => s.isOwned).length;
    final total = stickers.length;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  '$owned de $total',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '${total == 0 ? 0 : ((owned / total) * 100).round()}%',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemCount: stickers.length,
            itemBuilder: (context, i) {
              final s = stickers[i];
              return StickerTile(
                sticker: s,
                onIncrement: () => p.increment(s.id),
                onDecrement: () => p.decrement(s.id),
                onLongPress: () => showStickerCounterSheet(context, s.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
