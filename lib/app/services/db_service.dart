import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

abstract final class DbService {
  static const String _databaseName = 'om_yahya_recitation_center.db';
  static const String _tenantsTableName = 'tenants';
  static const String _recitationsTableName = 'recitations';

  static late final Future<Database> _database;

  static Future<void> init() async {
    if (!kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _database = openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE $_tenantsTableName (
      id INTEGER PRIMARY KEY,
      first_name TEXT NOT NULL,
      middle_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      joined_at TEXT NOT NULL,
      avg_score_from_hundred INTEGER NOT NULL DEFAULT 0,
      latest_surah_number INTEGER NOT NULL DEFAULT 1,
      latest_q_part INTEGER NOT NULL DEFAULT 1,
      latest_q_verse INTEGER NOT NULL DEFAULT 1
    )
  ''');

        await db.execute('''
    CREATE TABLE $_recitationsTableName (
      id INTEGER PRIMARY KEY,
      tenant_id INTEGER NOT NULL,
      recited_at TEXT NOT NULL,
      rewayah TEXT NOT NULL,
      q_part INTEGER NOT NULL,
      surah_number INTEGER NOT NULL,
      start_q_verse INTEGER NOT NULL,
      end_q_verse INTEGER NOT NULL,
      recite_score INTEGER NOT NULL,
      tajweed_score INTEGER NOT NULL,
      memory_score INTEGER NOT NULL,
      notes TEXT,

      FOREIGN KEY (tenant_id)
        REFERENCES $_tenantsTableName(id)
        ON DELETE CASCADE
    )
  ''');
      },
    );
  }

  static Future<List<TenantModel>> tenants() async {
    final db = await _database;

    final List<Map<String, dynamic>> tenantsMaps = await db.query(
      _tenantsTableName,
    );

    return tenantsMaps.map(TenantModel.fromMap).toList();
  }

  static Future<List<RecitationModel>> recitationsForTenant(
    int tenantId,
  ) async {
    final db = await _database;

    final List<Map<String, dynamic>> recitationsMaps = await db.query(
      _recitationsTableName,
      where: 'tenant_id = ?',
      whereArgs: [tenantId],
    );

    return recitationsMaps.map(RecitationModel.fromMap).toList();
  }

  static Future<void> insertTenant(TenantModel tenant) async {
    final db = await _database;
    await db.insert(
      _tenantsTableName,
      tenant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertRecitation(RecitationModel recitation) async {
    final db = await _database;
    await db.insert(
      _recitationsTableName,
      recitation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
