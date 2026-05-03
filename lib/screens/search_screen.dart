import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sticker.dart';
import '../providers/sticker_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Sticker> _search(StickerProvider p) {
    if (_query.trim().isEmpty) return [];
    final q = _query.trim().toLowerCase();
    return p.all.where((s) {
      return s.label.toLowerCase().contains(q) ||
          s.displayName.toLowerCase().contains(q) ||
          s.section.toLowerCase().contains(q) ||
          (s.customName?.toLowerCase().contains(q) ?? false);
    }).toList()
      ..sort((a, b) {
        // Exact label match first
        final aExact = a.label.toLowerCase() == q ? 0 : 1;
        final bExact = b.label.toLowerCase() == q ? 0 : 1;
        if (aExact != bExact) return aExact.compareTo(bExact);
        // Then label starts with query
        final aStarts = a.label.toLowerCase().startsWith(q) ? 0 : 1;
        final bStarts = b.label.toLowerCase().startsWith(q) ? 0 : 1;
        if (aStarts != bStarts) return aStarts.compareTo(bStarts);
        return a.label.compareTo(b.label);
      });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    final results = _search(p);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar barajita'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Número, nombre o sección…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? _EmptyPrompt(scheme: scheme)
          : results.isEmpty
              ? _NoResults(query: _query, scheme: scheme)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _StickerResultCard(
                    sticker: results[i],
                    highlight: _query.trim().toLowerCase(),
                  ),
                ),
    );
  }
}

// ──────────────────────────────────────────────
// Empty state — before typing
// ──────────────────────────────────────────────
class _EmptyPrompt extends StatelessWidget {
  final ColorScheme scheme;
  const _EmptyPrompt({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, size: 72, color: scheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Escribe el número o nombre\nde la barajita',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ej: "URU 1", "Messi", "FWC"',
            style: TextStyle(
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// No results state
// ──────────────────────────────────────────────
class _NoResults extends StatelessWidget {
  final String query;
  final ColorScheme scheme;
  const _NoResults({required this.query, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.find_replace_rounded, size: 64, color: scheme.error.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'Sin resultados para "$query"',
            style: TextStyle(fontSize: 16, color: scheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Result card — single sticker
// ──────────────────────────────────────────────
class _StickerResultCard extends StatelessWidget {
  final Sticker sticker;
  final String highlight;

  const _StickerResultCard({required this.sticker, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final _StatusInfo info = _statusInfo(sticker, scheme);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: info.bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: info.borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Label badge ──────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: info.badgeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                sticker.label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: info.badgeTextColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // ── Name & section ───────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sticker.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sticker.section,
                    style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.55)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ── Status chip + quick actions ───────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusChip(info: info),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrement
                    _CircleAction(
                      icon: Icons.remove_rounded,
                      color: scheme.error,
                      onTap: sticker.owned > 0
                          ? () => context.read<StickerProvider>().decrement(sticker.id)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${sticker.owned}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                    // Increment
                    _CircleAction(
                      icon: Icons.add_rounded,
                      color: scheme.primary,
                      onTap: () => context.read<StickerProvider>().increment(sticker.id),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Status helpers
// ──────────────────────────────────────────────
class _StatusInfo {
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color chipBg;
  final Color chipFg;
  final IconData icon;

  const _StatusInfo({
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.chipBg,
    required this.chipFg,
    required this.icon,
  });
}

_StatusInfo _statusInfo(Sticker s, ColorScheme scheme) {
  if (!s.isOwned) {
    return _StatusInfo(
      label: 'Falta',
      bgColor: scheme.errorContainer.withValues(alpha: 0.18),
      borderColor: scheme.error.withValues(alpha: 0.35),
      badgeColor: scheme.error.withValues(alpha: 0.15),
      badgeTextColor: scheme.error,
      chipBg: scheme.errorContainer,
      chipFg: scheme.onErrorContainer,
      icon: Icons.close_rounded,
    );
  } else if (s.duplicates > 0) {
    return _StatusInfo(
      label: 'Repetida ×${s.duplicates}',
      bgColor: scheme.tertiaryContainer.withValues(alpha: 0.25),
      borderColor: scheme.tertiary.withValues(alpha: 0.45),
      badgeColor: scheme.tertiary.withValues(alpha: 0.2),
      badgeTextColor: scheme.tertiary,
      chipBg: scheme.tertiaryContainer,
      chipFg: scheme.onTertiaryContainer,
      icon: Icons.copy_all_rounded,
    );
  } else {
    return _StatusInfo(
      label: 'Tengo',
      bgColor: scheme.primaryContainer.withValues(alpha: 0.22),
      borderColor: scheme.primary.withValues(alpha: 0.4),
      badgeColor: scheme.primary.withValues(alpha: 0.15),
      badgeTextColor: scheme.primary,
      chipBg: scheme.primaryContainer,
      chipFg: scheme.onPrimaryContainer,
      icon: Icons.check_rounded,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _StatusInfo info;
  const _StatusChip({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: info.chipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.icon, size: 13, color: info.chipFg),
          const SizedBox(width: 4),
          Text(
            info.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: info.chipFg,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _CircleAction({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: onTap != null ? color.withValues(alpha: 0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: onTap != null ? color.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? color : color.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}
