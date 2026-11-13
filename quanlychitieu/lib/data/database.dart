import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/txn.dart';

class Db {
  static Database? _db;

  static Future<Database> get _database async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    if (kIsWeb) databaseFactory = databaseFactoryFfiWebNoWebWorker;

    final path = kIsWeb
        ? 'expense.db'
        : join(await getDatabasesPath(), 'expense.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (d, _) {
        return d.execute('''
          CREATE TABLE txn(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            income INTEGER NOT NULL,
            cat TEXT NOT NULL,
            note TEXT NOT NULL,
            date INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<List<Txn>> month(DateTime m) async {
    final d = await _database;
    final rows = await d.query(
      'txn',
      where: 'date >= ? AND date < ?',
      whereArgs: [
        DateTime(m.year, m.month).millisecondsSinceEpoch,
        DateTime(m.year, m.month + 1).millisecondsSinceEpoch,
      ],
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(Txn.fromMap).toList();
  }

  static Future<void> save(Txn t) async {
    final d = await _database;
    if (t.id == null) {
      await d.insert('txn', t.toMap()..remove('id'));
    } else {
      await d.update('txn', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    }
  }
}
