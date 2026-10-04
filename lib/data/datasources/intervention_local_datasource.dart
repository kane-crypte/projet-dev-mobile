import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/intervention_model.dart';

class InterventionLocalDataSource {
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'terrain_pro.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
        CREATE TABLE interventions(
          id INTEGER PRIMARY KEY,
          client TEXT, address TEXT, description TEXT, equipment TEXT,
          status TEXT, priority INTEGER, lat REAL, lng REAL,
          notes TEXT, photos TEXT, signature_path TEXT
        )''');
        await db.execute('''
        CREATE TABLE sync_queue(
          queue_id INTEGER PRIMARY KEY AUTOINCREMENT,
          intervention_id INTEGER,
          payload TEXT,
          created_at TEXT
        )''');
      },
    );
    return _db!;
  }

  Future<List<InterventionModel>> getAll() async {
    final db = await _database;
    final rows = await db.query('interventions', orderBy: 'priority ASC');
    return rows.map(InterventionModel.fromMap).toList();
  }

  /// Enregistre les données venues de l'API, sans écraser
  /// les modifications locales encore en attente de synchro.
  Future<void> saveAll(List<InterventionModel> items) async {
    final db = await _database;
    final pending = await pendingIds();
    final batch = db.batch();
    for (final m in items) {
      if (pending.contains(m.id)) continue;
      batch.insert(
        'interventions',
        m.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> save(InterventionModel m) async {
    final db = await _database;
    await db.insert(
      'interventions',
      m.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---- File d'attente de synchronisation ----
  Future<void> enqueue(InterventionModel m) async {
    final db = await _database;
    await db.insert('sync_queue', {
      'intervention_id': m.id,
      'payload': jsonEncode(m.toJson()),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getQueue() async {
    final db = await _database;
    return db.query('sync_queue', orderBy: 'queue_id ASC');
  }

  Future<void> removeFromQueue(int queueId) async {
    final db = await _database;
    await db.delete('sync_queue', where: 'queue_id = ?', whereArgs: [queueId]);
  }

  Future<Set<int>> pendingIds() async {
    final db = await _database;
    final rows = await db.query('sync_queue', columns: ['intervention_id']);
    return rows.map((r) => r['intervention_id'] as int).toSet();
  }
}
