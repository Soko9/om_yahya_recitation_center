import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
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
    await 1.sec.wait();
    return tenantsMaps.map(TenantModel.fromMap).toList();
  }

  static Future<List<RecitationModel>> recitationsByDate(DateTime date) async {
    final db = await _database;

    final List<Map<String, dynamic>> recitationsMaps = await db.rawQuery(
      '''
        SELECT r.*, 
        CASE
        WHEN t.id IS NULL THEN NULL
          ELSE json_object(
            'id', t.id,
            'first_name', t.first_name,
            'middle_name', t.middle_name,
            'last_name', t.last_name,
            'joined_at', t.joined_at,
            'avg_score_from_hundred', t.avg_score_from_hundred,
            'latest_surah_number', t.latest_surah_number,
            'latest_q_part', t.latest_q_part,
            'latest_q_verse', t.latest_q_verse
          )
        END AS tenant FROM $_recitationsTableName as r
        LEFT JOIN $_tenantsTableName as t
        ON r.tenant_id = t.id
        WHERE recited_at = ?
      ''',
      [date.toIsoMap],
    );
    await 2.sec.wait();
    return recitationsMaps.map(RecitationModel.fromMap).toList();
  }

  static Future<List<RecitationModel>> recitationsByTenant(int tenantId) async {
    final db = await _database;

    final List<Map<String, dynamic>> recitationsMaps = await db.rawQuery(
      '''
        SELECT * FROM $_recitationsTableName
        LEFT JOIN $_tenantsTableName
        ON $_recitationsTableName.tenant_id = $_tenantsTableName.id
        WHERE tenant_id = ?
      ''',
      [tenantId],
    );
    await 2.sec.wait();
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
    await db.transaction((txn) async {
      await txn.insert(
        _recitationsTableName,
        recitation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _refreshTenantStats(txn, recitation.tenantId);
    });
  }

  static Future<void> updateTenant(TenantModel tenant) async {
    final db = await _database;
    await db.update(
      _tenantsTableName,
      tenant.toMap(),
      where: 'id = ?',
      whereArgs: [tenant.id],
    );
  }

  static Future<void> deleteTenant(int tenantId) async {
    final db = await _database;
    await db.delete(_tenantsTableName, where: 'id = ?', whereArgs: [tenantId]);
  }

  static Future<void> deleteRecitation(int recitationId) async {
    final db = await _database;
    await db.transaction((txn) async {
      final result = await txn.query(
        _recitationsTableName,
        columns: ['tenant_id'],
        where: 'id = ?',
        whereArgs: [recitationId],
        limit: 1,
      );

      if (result.isEmpty) return;

      final tenantId = result.first['tenant_id']! as int;

      await txn.delete(
        _recitationsTableName,
        where: 'id = ?',
        whereArgs: [recitationId],
      );

      await _refreshTenantStats(txn, tenantId);
    });
  }

  static Future<void> _refreshTenantStats(
    DatabaseExecutor db,
    int tenantId,
  ) async {
    final scoreResult = await db.rawQuery(
      '''
    SELECT ROUND(
      AVG(
        (recite_score + tajweed_score + memory_score) * 100.0 / 30
      )
    ) AS avg_score
    FROM $_recitationsTableName
    WHERE tenant_id = ?
    ''',
      [tenantId],
    );

    final avgScore = scoreResult.first['avg_score'] as double? ?? 0;

    final latestResult = await db.query(
      _recitationsTableName,
      columns: ['surah_number', 'q_part', 'end_q_verse'],
      where: 'tenant_id = ?',
      whereArgs: [tenantId],
      orderBy: 'recited_at DESC, id DESC',
      limit: 1,
    );

    final latest = latestResult.isEmpty ? null : latestResult.first;

    await db.update(
      _tenantsTableName,
      {
        'avg_score_from_hundred': avgScore,
        'latest_surah_number': latest?['surah_number'] ?? 1,
        'latest_q_part': latest?['q_part'] ?? 1,
        'latest_q_verse': latest?['end_q_verse'] ?? 1,
      },
      where: 'id = ?',
      whereArgs: [tenantId],
    );
  }

  static Future<void> clearDb() async {
    final db = await _database;
    await db.delete(_tenantsTableName);
    await db.delete(_recitationsTableName);
  }
}
