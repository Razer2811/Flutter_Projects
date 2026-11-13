import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'moneyflow.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount INTEGER NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        note TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    return (await database).insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    final maps = await (await database).query(
      'transactions',
      orderBy: 'createdAt DESC',
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    return (await database).update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    return (await database).delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
