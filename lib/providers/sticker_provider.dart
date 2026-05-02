import 'package:flutter/foundation.dart';

import '../data/database.dart';
import '../models/sticker.dart';
import '../models/team.dart';
import '../data/seed_data.dart';

class StickerProvider extends ChangeNotifier {
  final StickerDatabase _db = StickerDatabase.instance;
  final Map<String, Sticker> _byId = {};
  bool _loaded = false;

  bool get loaded => _loaded;

  List<Sticker> get all => _byId.values.toList();

  Future<void> load() async {
    final list = await _db.getAll();
    _byId
      ..clear()
      ..addEntries(list.map((s) => MapEntry(s.id, s)));
    _loaded = true;
    notifyListeners();
  }

  Sticker? byId(String id) => _byId[id];

  List<Sticker> forTeam(String teamCode) {
    return _byId.values.where((s) => s.teamCode == teamCode).toList()
      ..sort((a, b) => a.orderInTeam.compareTo(b.orderInTeam));
  }

  List<Sticker> bySection(String section) {
    return _byId.values.where((s) => s.section == section).toList()
      ..sort((a, b) => a.orderInTeam.compareTo(b.orderInTeam));
  }

  List<Sticker> get duplicates =>
      _byId.values.where((s) => s.duplicates > 0).toList()
        ..sort((a, b) {
          final cmp = b.duplicates.compareTo(a.duplicates);
          if (cmp != 0) return cmp;
          return a.label.compareTo(b.label);
        });

  List<Sticker> get missing =>
      _byId.values.where((s) => !s.isOwned).toList()
        ..sort((a, b) => a.label.compareTo(b.label));

  int get totalCount => _byId.length;
  int get ownedUniqueCount => _byId.values.where((s) => s.isOwned).length;
  int get duplicatesCount =>
      _byId.values.fold(0, (sum, s) => sum + s.duplicates);
  int get missingCount => totalCount - ownedUniqueCount;
  double get progress => totalCount == 0 ? 0 : ownedUniqueCount / totalCount;

  int teamOwned(String teamCode) =>
      forTeam(teamCode).where((s) => s.isOwned).length;
  int teamTotal(String teamCode) => forTeam(teamCode).length;

  int groupOwned(String groupCode) {
    final group = kGroups.firstWhere((g) => g.code == groupCode);
    return group.teams.fold(0, (a, t) => a + teamOwned(t.code));
  }

  int groupTotal(String groupCode) {
    final group = kGroups.firstWhere((g) => g.code == groupCode);
    return group.teams.fold(0, (a, t) => a + teamTotal(t.code));
  }

  Future<void> increment(String id) async {
    final s = _byId[id];
    if (s == null) return;
    s.owned += 1;
    await _db.updateOwned(id, s.owned);
    notifyListeners();
  }

  Future<void> decrement(String id) async {
    final s = _byId[id];
    if (s == null) return;
    if (s.owned == 0) return;
    s.owned -= 1;
    await _db.updateOwned(id, s.owned);
    notifyListeners();
  }

  Future<void> setOwned(String id, int value) async {
    final s = _byId[id];
    if (s == null) return;
    s.owned = value < 0 ? 0 : value;
    await _db.updateOwned(id, s.owned);
    notifyListeners();
  }

  Future<void> renameSticker(String id, String? customName) async {
    final s = _byId[id];
    if (s == null) return;
    final clean = customName?.trim();
    s.customName = (clean == null || clean.isEmpty) ? null : clean;
    await _db.updateCustomName(id, s.customName);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _db.resetAll();
    for (final s in _byId.values) {
      s.owned = 0;
    }
    notifyListeners();
  }

  String exportDuplicatesText() {
    final lines = <String>[];
    lines.add('🔁 Barajitas repetidas — Panini FIFA 2026');
    final dups = duplicates;
    if (dups.isEmpty) {
      lines.add('Sin repetidas.');
      return lines.join('\n');
    }
    final bySection = <String, List<Sticker>>{};
    for (final s in dups) {
      bySection.putIfAbsent(s.section, () => []).add(s);
    }
    bySection.forEach((section, items) {
      lines.add('\n• $section');
      for (final s in items) {
        lines.add('  ${s.label} — ${s.displayName}  ×${s.duplicates}');
      }
    });
    return lines.join('\n');
  }
}
