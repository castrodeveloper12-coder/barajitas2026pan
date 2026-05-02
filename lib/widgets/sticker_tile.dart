import 'package:flutter/material.dart';

import '../models/sticker.dart';

class StickerTile extends StatelessWidget {
  final Sticker sticker;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onLongPress;

  const StickerTile({
    super.key,
    required this.sticker,
    required this.onIncrement,
    required this.onDecrement,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final has = sticker.isOwned;
    final dups = sticker.duplicates;

    Color bg;
    Color border;
    if (!has) {
      bg = scheme.surfaceContainerHighest.withValues(alpha: 0.4);
      border = scheme.outlineVariant.withValues(alpha: 0.5);
    } else if (dups > 0) {
      bg = scheme.tertiary.withValues(alpha: 0.18);
      border = scheme.tertiary.withValues(alpha: 0.6);
    } else {
      bg = scheme.primary.withValues(alpha: 0.15);
      border = scheme.primary.withValues(alpha: 0.6);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onIncrement,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1.4),
        ),
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sticker.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: has ? scheme.onSurface : scheme.onSurfaceVariant,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sticker.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
            if (has)
              Positioned(
                top: -4,
                right: -4,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onDecrement,
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.errorContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.error.withValues(alpha: 0.7),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.remove_rounded,
                          size: 16,
                          color: scheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (has)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: dups > 0 ? scheme.tertiary : scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    dups > 0 ? Icons.swap_horiz_rounded : Icons.check_rounded,
                    size: 12,
                    color: dups > 0 ? scheme.onTertiary : scheme.onPrimary,
                  ),
                ),
              ),
            if (dups > 0)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.tertiary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+$dups',
                    style: TextStyle(
                      color: scheme.onTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
