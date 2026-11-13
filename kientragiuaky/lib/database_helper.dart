import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TxCategory {
  final int id;
  final String name;
  final int iconCode;
  final int type; // 1: Thu, -1: Chi

  TxCategory({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.type,
  });

  factory TxCategory.fromMap(Map<String, dynamic> map) => TxCategory(
    id: map['id'],
    name: map['name'],
    iconCode: map['icon_code'],
    type: map['type'],
  );
}

class TransactionModel {
  final int? id;
  final double amount;
  final int categoryId;
  final int date;
  final String? note;
  final String? categoryName;
  final int? categoryIcon;
  final int? type;

  TransactionModel({
    this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
    this.categoryName,
    this.categoryIcon,
    this.type,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'category_id': categoryId,
    'date': date,
    'note': note,
  };
}

class BudgetModel {
  final int categoryId;
  final String month;
  final double limit;

  const BudgetModel({
    required this.categoryId,
    required this.month,
    required this.limit,
  });
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const _webTransactionsKey = 'minimal_expense_transactions';
  static const _webBudgetsKey = 'minimal_expense_budgets';

  DatabaseHelper._init();

  static List<TxCategory> get _webCategories => [
    TxCategory(
      id: 1,
      name: 'Ăn uống',
      iconCode: Icons.restaurant_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 2,
      name: 'Di chuyển',
      iconCode: Icons.directions_car_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 3,
      name: 'Mua sắm',
      iconCode: Icons.shopping_bag_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 4,
      name: 'Lương',
      iconCode: Icons.account_balance_wallet_outlined.codePoint,
      type: 1,
    ),
    TxCategory(
      id: 5,
      name: 'Hóa đơn',
      iconCode: Icons.receipt_long_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 6,
      name: 'Giải trí',
      iconCode: Icons.movie_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 7,
      name: 'Sức khỏe',
      iconCode: Icons.health_and_safety_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 8,
      name: 'Nhà ở',
      iconCode: Icons.home_outlined.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 9,
      name: 'Khác',
      iconCode: Icons.grid_view_rounded.codePoint,
      type: -1,
    ),
    TxCategory(
      id: 10,
      name: 'Thưởng',
      iconCode: Icons.card_giftcard_outlined.codePoint,
      type: 1,
    ),
    TxCategory(
      id: 11,
      name: 'Kinh doanh',
      iconCode: Icons.storefront_outlined.codePoint,
      type: 1,
    ),
    TxCategory(
      id: 12,
      name: 'Đầu tư',
      iconCode: Icons.trending_up_outlined.codePoint,
      type: 1,
    ),
    TxCategory(
      id: 13,
      name: 'Khác',
      iconCode: Icons.more_horiz_outlined.codePoint,
      type: 1,
    ),
  ];

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('minimal_expense.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon_code INTEGER NOT NULL,
        type INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category_id INTEGER NOT NULL,
        date INTEGER NOT NULL,
        note TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await _seedCategories(db);
    await db.execute('''
      CREATE TABLE budgets (
        category_id INTEGER NOT NULL,
        month TEXT NOT NULL,
        amount REAL NOT NULL,
        PRIMARY KEY (category_id, month),
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN note TEXT');
      await _seedCategories(db);
      await db.execute('''
        CREATE TABLE budgets (
          category_id INTEGER NOT NULL,
          month TEXT NOT NULL,
          amount REAL NOT NULL,
          PRIMARY KEY (category_id, month),
          FOREIGN KEY (category_id) REFERENCES categories (id)
        )
      ''');
    }
  }

  Future<void> _seedCategories(Database db) async {
    for (final category in _webCategories) {
      final existing = await db.query(
        'categories',
        columns: ['id'],
        where: 'name = ? AND type = ?',
        whereArgs: [category.name, category.type],
        limit: 1,
      );
      if (existing.isEmpty) {
        await db.insert('categories', {
          'name': category.name,
          'icon_code': category.iconCode,
          'type': category.type,
        });
      }
    }
  }

  Future<List<TxCategory>> getCategories() async {
    if (kIsWeb) return _webCategories;
    final db = await instance.database;
    final result = await db.query('categories');
    return result.map((json) => TxCategory.fromMap(json)).toList();
  }

  Future<void> insertTransaction(TransactionModel tx) async {
    if (kIsWeb) {
      final preferences = await SharedPreferences.getInstance();
      final transactions = await _getWebTransactions(preferences);
      final nextId =
          transactions.fold<int>(
            0,
            (maxId, item) =>
                item.id != null && item.id! > maxId ? item.id! : maxId,
          ) +
          1;
      final saved = {
        'id': nextId,
        'amount': tx.amount,
        'category_id': tx.categoryId,
        'date': tx.date,
        'note': tx.note,
      };
      final raw = preferences.getStringList(_webTransactionsKey) ?? [];
      raw.add(jsonEncode(saved));
      if (!await preferences.setStringList(_webTransactionsKey, raw)) {
        throw StateError('Không thể lưu giao dịch trên trình duyệt');
      }
      return;
    }
    final db = await instance.database;
    await db.insert('transactions', tx.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    if (kIsWeb) {
      final preferences = await SharedPreferences.getInstance();
      return _getWebTransactions(preferences);
    }
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT t.*, c.name as categoryName, c.icon_code as categoryIcon, c.type
      FROM transactions t
      JOIN categories c ON t.category_id = c.id
      ORDER BY t.date DESC
    ''');

    return result
        .map(
          (map) => TransactionModel(
            id: map['id'] as int,
            amount: (map['amount'] as num).toDouble(),
            categoryId: map['category_id'] as int,
            date: map['date'] as int,
            note: map['note'] as String?,
            categoryName: map['categoryName'] as String,
            categoryIcon: map['categoryIcon'] as int,
            type: map['type'] as int,
          ),
        )
        .toList();
  }

  Future<double> getBalance() async {
    if (kIsWeb) {
      final transactions = await getTransactions();
      return transactions.fold<double>(
        0,
        (balance, transaction) =>
            balance + transaction.amount * (transaction.type ?? 0),
      );
    }
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT SUM(t.amount * c.type) as total
      FROM transactions t
      JOIN categories c ON t.category_id = c.id
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<List<BudgetModel>> getBudgets(String month) async {
    if (kIsWeb) {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getStringList(_webBudgetsKey) ?? [];
      return raw
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .where((map) => map['month'] == month)
          .map(
            (map) => BudgetModel(
              categoryId: map['category_id'] as int,
              month: map['month'] as String,
              limit: (map['amount'] as num).toDouble(),
            ),
          )
          .toList();
    }
    final db = await instance.database;
    final result = await db.query(
      'budgets',
      where: 'month = ?',
      whereArgs: [month],
    );
    return result
        .map(
          (map) => BudgetModel(
            categoryId: map['category_id'] as int,
            month: map['month'] as String,
            limit: (map['amount'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<void> saveBudget(BudgetModel budget) async {
    if (kIsWeb) {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getStringList(_webBudgetsKey) ?? [];
      raw.removeWhere((item) {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return map['category_id'] == budget.categoryId &&
            map['month'] == budget.month;
      });
      raw.add(
        jsonEncode({
          'category_id': budget.categoryId,
          'month': budget.month,
          'amount': budget.limit,
        }),
      );
      if (!await preferences.setStringList(_webBudgetsKey, raw)) {
        throw StateError('Không thể lưu ngân sách trên trình duyệt');
      }
      return;
    }
    final db = await instance.database;
    await db.insert('budgets', {
      'category_id': budget.categoryId,
      'month': budget.month,
      'amount': budget.limit,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TransactionModel>> _getWebTransactions(
    SharedPreferences preferences,
  ) async {
    final categories = {
      for (final category in _webCategories) category.id: category,
    };
    final raw = preferences.getStringList(_webTransactionsKey) ?? [];
    final transactions = raw.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      final categoryId = map['category_id'] as int;
      final category = categories[categoryId];
      if (category == null) {
        throw StateError('Danh mục giao dịch không hợp lệ: $categoryId');
      }
      return TransactionModel(
        id: map['id'] as int,
        amount: (map['amount'] as num).toDouble(),
        categoryId: categoryId,
        date: map['date'] as int,
        note: map['note'] as String?,
        categoryName: category.name,
        categoryIcon: category.iconCode,
        type: category.type,
      );
    }).toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }
}
