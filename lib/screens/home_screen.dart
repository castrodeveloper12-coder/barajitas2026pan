import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sticker_provider.dart';
import '../widgets/progress_card.dart';
import 'duplicates_screen.dart';
import 'groups_screen.dart';
import 'matches_screen.dart';
import 'search_screen.dart';
import 'specials_screen.dart';
import 'missing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StickerProvider>();
    if (!p.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panini FIFA 2026'),
        actions: [
          IconButton(
            tooltip: 'Buscar barajita',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Reiniciar',
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ProgressCard(
              owned: p.ownedUniqueCount,
              total: p.totalCount,
              duplicates: p.duplicatesCount,
              missing: p.missingCount,
            ),
            const SizedBox(height: 16),
            // ── Quick search card ─────────────────────────
            _SearchCard(),
            const SizedBox(height: 20),
            Text(
              'Explorar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            _NavCard(
              icon: Icons.flag_rounded,
              title: 'Grupos y equipos',
              subtitle: '12 grupos · 48 selecciones',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GroupsScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _NavCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Especiales',
              subtitle: 'FWC (00–19) · Coca-Cola Legends',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SpecialsScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _NavCard(
              icon: Icons.calendar_month_rounded,
              title: 'Calendario',
              subtitle: 'Partidos, resultados y posiciones',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MatchesScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _NavCard(
              icon: Icons.swap_horiz_rounded,
              title: 'Repetidas (intercambio)',
              subtitle: '${p.duplicatesCount} barajitas para intercambiar',
              accent: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DuplicatesScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _NavCard(
              icon: Icons.list_alt_rounded,
              title: 'Faltantes',
              subtitle: '${p.missingCount} barajitas por conseguir',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MissingScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reiniciar álbum'),
        content: const Text(
          '¿Seguro que quieres borrar todas las barajitas registradas? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<StickerProvider>().resetAll();
    }
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool accent;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: accent
          ? scheme.tertiaryContainer.withValues(alpha: 0.55)
          : scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent ? scheme.tertiary : scheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: accent ? scheme.onTertiary : scheme.onPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick search card ──────────────────────────────────────────────────────
class _SearchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.primary.withValues(alpha: 0.85),
                scheme.secondary.withValues(alpha: 0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: scheme.onPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.search_rounded, color: scheme.onPrimary, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Búsqueda rápida',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: scheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '¿La tengo? ¿Me falta? ¿Repetida?',
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: scheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
