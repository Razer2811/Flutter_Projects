import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static const _storageKey = 'moneyflow_transactions';

  Future<List<TransactionModel>> getTransactions() async {
    final preferences = await SharedPreferences.getInstance();
    final rawTransactions = preferences.getStringList(_storageKey) ?? [];
    final transactions = rawTransactions
        .map(
          (item) => TransactionModel.fromMap(
            jsonDecode(item) as Map<String, dynamic>,
          ),
        )
        .toList();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    final nextId =
        transactions.fold<int>(
          0,
          (maxId, item) =>
              item.id != null && item.id! > maxId ? item.id! : maxId,
        ) +
        1;
    final preferences = await SharedPreferences.getInstance();
    final savedTransaction = TransactionModel(
      id: nextId,
      title: transaction.title,
      amount: transaction.amount,
      type: transaction.type,
      category: transaction.category,
      note: transaction.note,
      createdAt: transaction.createdAt,
    );
    transactions.add(savedTransaction);
    await _save(preferences, transactions);
    return nextId;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) return 0;
    transactions[index] = transaction;
    final preferences = await SharedPreferences.getInstance();
    await _save(preferences, transactions);
    return 1;
  }

  Future<int> deleteTransaction(int id) async {
    final transactions = await getTransactions();
    final originalLength = transactions.length;
    transactions.removeWhere((item) => item.id == id);
    if (transactions.length == originalLength) return 0;
    final preferences = await SharedPreferences.getInstance();
    await _save(preferences, transactions);
    return 1;
  }

  Future<void> closeDatabase() async {}

  Future<void> _save(
    SharedPreferences preferences,
    List<TransactionModel> transactions,
  ) async {
    await preferences.setStringList(
      _storageKey,
      transactions.map((item) => jsonEncode(item.toMap())).toList(),
    );
  }
}
