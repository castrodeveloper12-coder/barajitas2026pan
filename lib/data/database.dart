import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/sticker.dart';
import 'seed_data.dart';

class StickerDatabase {
  StickerDatabase._();
  static final StickerDatabase instance = StickerDatabase._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'panini_2026.db');
    final db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE stickers (
            id TEXT PRIMARY KEY,
            label TEXT NOT NULL,
            name TEXT NOT NULL,
            section TEXT NOT NULL,
            group_code TEXT,
            team_code TEXT,
            kind TEXT NOT NULL,
            order_in_team INTEGER NOT NULL,
            owned INTEGER NOT NULL DEFAULT 0,
            custom_name TEXT
          )
        ''');
        final batch = db.batch();
        for (final s in buildAllStickers()) {
          batch.insert('stickers', s.toMap());
        }
        await batch.commit(noResult: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE stickers ADD COLUMN custom_name TEXT",
          );
        }
      },
    );
    // Mantén siempre los nombres y secciones por defecto sincronizados
    // con el código (sin tocar 'owned' ni 'custom_name').
    await _syncDefaults(db);
    return db;
  }

  Future<void> _syncDefaults(Database db) async {
    final batch = db.batch();
    for (final s in buildAllStickers()) {
      batch.rawInsert(
        '''INSERT INTO stickers
             (id, label, name, section, group_code, team_code, kind, order_in_team, owned)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)
           ON CONFLICT(id) DO UPDATE SET
             label = excluded.label,
             name = excluded.name,
             section = excluded.section,
             group_code = excluded.group_code,
             team_code = excluded.team_code,
             kind = excluded.kind,
             order_in_team = excluded.order_in_team
        ''',
        [
          s.id,
          s.label,
          s.name,
          s.section,
          s.groupCode,
          s.teamCode,
          s.kind.name,
          s.orderInTeam,
        ],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Sticker>> getAll() async {
    final db = await database;
    final rows = await db.query('stickers');
    return rows.map(Sticker.fromMap).toList();
  }

  Future<void> updateOwned(String id, int owned) async {
    final db = await database;
    await db.update(
      'stickers',
      {'owned': owned < 0 ? 0 : owned},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCustomName(String id, String? customName) async {
    final db = await database;
    await db.update(
      'stickers',
      {'custom_name': customName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resetAll() async {
    final db = await database;
    await db.update('stickers', {'owned': 0});
  }
}
