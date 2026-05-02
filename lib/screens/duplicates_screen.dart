import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/sticker.dart';
import '../providers/sticker_provider.dart';

class DuplicatesScreen extends StatelessWidget {
  const DuplicatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    final dups = p.duplicates;
    final scheme = Theme.of(context).colorScheme;

    final grouped = <String, List<Sticker>>{};
    for (final s in dups) {
      grouped.putIfAbsent(s.section, () => []).add(s);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repetidas'),
        actions: [
          IconButton(
            tooltip: 'Compartir lista',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: dups.isEmpty
                ? null
                : () => Share.share(
                      p.exportDuplicatesText(),
                      subject: 'Barajitas repetidas Panini FIFA 2026',
                    ),
          ),
        ],
      ),
      body: dups.isEmpty
          ? _EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'Sin repetidas',
              subtitle:
                  'Cuando registres más de una copia de la misma barajita, aparecerá aquí.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.tertiaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded,
                          color: scheme.onTertiaryContainer),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${p.duplicatesCount} barajitas para intercambiar',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...grouped.entries.map(
                  (e) => _DupSection(section: e.key, items: e.value),
                ),
              ],
            ),
    );
  }
}

class _DupSection extends StatelessWidget {
  final String section;
  final List<Sticker> items;
  const _DupSection({required this.section, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 0, 6),
            child: Text(
              section,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                for (final s in items) _DupRow(sticker: s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DupRow extends StatelessWidget {
  final Sticker sticker;
  const _DupRow({required this.sticker});

  @override
  Widget build(BuildContext context) {
    final p = context.read<StickerProvider>();
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.tertiary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              sticker.label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: scheme.tertiary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              sticker.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline_rounded),
            onPressed: () => p.decrement(sticker.id),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.tertiary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '×${sticker.duplicates}',
              style: TextStyle(
                color: scheme.onTertiary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => p.increment(sticker.id),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.primary),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
