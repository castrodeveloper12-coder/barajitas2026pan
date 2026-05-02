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
    return openDatabase(
      path,
      version: 1,
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
            owned INTEGER NOT NULL DEFAULT 0
          )
        ''');
        final batch = db.batch();
        for (final s in buildAllStickers()) {
          batch.insert('stickers', s.toMap());
        }
        await batch.commit(noResult: true);
      },
    );
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

  Future<void> resetAll() async {
    final db = await database;
    await db.update('stickers', {'owned': 0});
  }
}
