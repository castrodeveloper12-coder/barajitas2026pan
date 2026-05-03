import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sticker.dart';
import '../providers/sticker_provider.dart';

class MissingScreen extends StatefulWidget {
  const MissingScreen({super.key});

  @override
  State<MissingScreen> createState() => _MissingScreenState();
}

class _MissingScreenState extends State<MissingScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    final missing = p.missing.where((s) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return s.displayName.toLowerCase().contains(q) ||
          s.label.toLowerCase().contains(q) ||
          s.section.toLowerCase().contains(q);
    }).toList();

    final grouped = <String, List<Sticker>>{};
    for (final s in missing) {
      grouped.putIfAbsent(s.section, () => []).add(s);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Faltantes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar país, sección o número',
                prefixIcon: const Icon(Icons.search_rounded),
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
            child: missing.isEmpty
                ? const Center(child: Text('¡Sin faltantes!'))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: grouped.entries
                        .map((e) =>
                            _MissingSection(section: e.key, items: e.value))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MissingSection extends StatelessWidget {
  final String section;
  final List<Sticker> items;
  const _MissingSection({required this.section, required this.items});

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
              '$section · ${items.length}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                for (final s in items) _MissingRow(sticker: s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingRow extends StatelessWidget {
  final Sticker sticker;
  const _MissingRow({required this.sticker});

  @override
  Widget build(BuildContext context) {
    final p = context.read<StickerProvider>();
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              sticker.label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              sticker.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Tengo'),
            onPressed: () => p.increment(sticker.id),
          ),
        ],
      ),
    );
  }
}
