import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/team.dart';
import '../models/tournament.dart';
import '../providers/tournament_provider.dart';
import 'matches_screen.dart';
import 'team_detail_screen.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchId;
  const MatchDetailScreen({super.key, required this.matchId});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final _homeCtrl = TextEditingController();
  final _awayCtrl = TextEditingController();
  final _homePenCtrl = TextEditingController();
  final _awayPenCtrl = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _homeCtrl.dispose();
    _awayCtrl.dispose();
    _homePenCtrl.dispose();
    _awayPenCtrl.dispose();
    super.dispose();
  }

  void _hydrate(WorldCupMatch m) {
    if (_initialized) return;
    _homeCtrl.text = m.homeScore?.toString() ?? '';
    _awayCtrl.text = m.awayScore?.toString() ?? '';
    _homePenCtrl.text = m.homePenalties?.toString() ?? '';
    _awayPenCtrl.text = m.awayPenalties?.toString() ?? '';
    _initialized = true;
  }

  int? _parseInt(TextEditingController c) {
    final t = c.text.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TournamentProvider>();
    final m = tp.matchById(widget.matchId);
    if (m == null) {
      return const Scaffold(body: Center(child: Text('Partido no encontrado')));
    }
    _hydrate(m);

    final scheme = Theme.of(context).colorScheme;
    final home = teamFromCode(m.resolvedHomeTeam);
    final away = teamFromCode(m.resolvedAwayTeam);
    final canEdit = home != null && away != null;

    final homeVal = _parseInt(_homeCtrl);
    final awayVal = _parseInt(_awayCtrl);
    final showPens = m.phase.isKnockout &&
        homeVal != null &&
        awayVal != null &&
        homeVal == awayVal;

    return Scaffold(
      appBar: AppBar(
        title: Text(m.phase == MatchPhase.group
            ? 'Grupo ${m.groupCode}'
            : m.phase.label),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.event_rounded,
                        size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      formatMatchDate(m.date),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.stadium_rounded,
                        size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${m.stadium} · ${m.city}',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TeamColumn(
                  team: home,
                  placeholder: m.homeTeamPlaceholder,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Text(
                  'vs',
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TeamColumn(
                  team: away,
                  placeholder: m.awayTeamPlaceholder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (!canEdit)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Aún no se conocen ambos rivales. Termina los partidos previos para poder registrar el resultado.',
                style: TextStyle(color: scheme.onTertiaryContainer),
              ),
            )
          else ...[
            Text('Resultado',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _scoreField(_homeCtrl, 'Local')),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('—',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(child: _scoreField(_awayCtrl, 'Visitante')),
              ],
            ),
            if (showPens) ...[
              const SizedBox(height: 16),
              Text('Penales',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _scoreField(_homePenCtrl, 'Pen. local')),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('—',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _scoreField(_awayPenCtrl, 'Pen. visitante')),
                ],
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => _save(context, m),
              icon: const Icon(Icons.save_rounded),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              label: const Text('Guardar resultado'),
            ),
            if (m.isPlayed) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _clear(context),
                icon: const Icon(Icons.delete_outline_rounded),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                label: const Text('Borrar resultado'),
              ),
            ],
          ],
          const SizedBox(height: 24),
          if (home != null) _stickerLink(context, home),
          if (away != null) ...[
            const SizedBox(height: 8),
            _stickerLink(context, away),
          ],
        ],
      ),
    );
  }

  Widget _scoreField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      textAlign: TextAlign.center,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _stickerLink(BuildContext context, Team t) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeamDetailScreen(team: t),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Text(t.flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ver barajitas de ${t.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WorldCupMatch m) async {
    final h = _parseInt(_homeCtrl);
    final a = _parseInt(_awayCtrl);
    if (h == null || a == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el resultado de ambos equipos')),
      );
      return;
    }
    int? hp;
    int? ap;
    if (m.phase.isKnockout && h == a) {
      hp = _parseInt(_homePenCtrl);
      ap = _parseInt(_awayPenCtrl);
      if (hp == null || ap == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('En eliminatoria, los empates necesitan penales')),
        );
        return;
      }
      if (hp == ap) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No puede haber empate en penales')),
        );
        return;
      }
    }

    await context
        .read<TournamentProvider>()
        .updateScore(m.id, h, a, homePen: hp, awayPen: ap);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resultado guardado')),
    );
  }

  Future<void> _clear(BuildContext context) async {
    await context.read<TournamentProvider>().clearScore(widget.matchId);
    if (mounted) {
      _homeCtrl.clear();
      _awayCtrl.clear();
      _homePenCtrl.clear();
      _awayPenCtrl.clear();
      setState(() {});
    }
  }
}

class _TeamColumn extends StatelessWidget {
  final Team? team;
  final String placeholder;
  const _TeamColumn({required this.team, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (team == null) {
      return Column(
        children: [
          const Text('—', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 4),
          Text(
            placeholderLabel(placeholder),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              fontSize: 13,
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        Text(team!.flag, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 4),
        Text(
          team!.code,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 2),
        Text(
          team!.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
