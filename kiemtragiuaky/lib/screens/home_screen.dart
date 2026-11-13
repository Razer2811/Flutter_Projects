import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import 'add_transaction_screen.dart';
import 'history_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> transactions = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  // Đọc dữ liệu từ SQLite
  Future<void> loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    if (!mounted) return;

    setState(() {
      transactions = data;
    });
  }

  // Tổng thu nhập
  int get totalIncome {
    return transactions
        .where((e) => e.type == 'income')
        .fold(0, (sum, e) => sum + e.amount);
  }

  // Tổng chi tiêu
  int get totalExpense {
    return transactions
        .where((e) => e.type == 'expense')
        .fold(0, (sum, e) => sum + e.amount);
  }

  // Số dư
  int get balance => totalIncome - totalExpense;

  // Mở màn hình thêm giao dịch
  Future<void> openAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );

    if (result == true) {
      loadTransactions();
    }
  }

  // Xóa giao dịch
  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await loadTransactions();
  }

  String formatMoney(int amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildCurrentScreen()),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddTransaction,
        backgroundColor: const Color(0xFF167C63),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add, size: 30),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }

  Widget buildCurrentScreen() {
    switch (selectedIndex) {
      case 1:
        return HistoryScreen(
          transactions: transactions,
          onDelete: deleteTransaction,
        );
      case 2:
        return StatisticsScreen(
          transactions: transactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          formatMoney: formatMoney,
        );
      default:
        return buildDashboard();
    }
  }

  Widget buildDashboard() {
    return RefreshIndicator(
      onRefresh: loadTransactions,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEFE8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFF167C63),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'MoneyFlow',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Thông báo',
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, size: 25),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Balance Card
          BalanceCard(
            balance: balance,
            income: totalIncome,
            expense: totalExpense,
          ),

          const SizedBox(height: 28),

          // Transaction Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF17211D),
                ),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Transaction List
          if (transactions.isEmpty)
            buildEmptyState()
          else
            ...transactions
                .take(5)
                .map(
                  (transaction) => TransactionItem(
                    transaction: transaction,
                    onDelete: () {
                      deleteTransaction(transaction.id!);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  // Trạng thái chưa có giao dịch
  Widget buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 55, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Chưa có giao dịch nào',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 5),
          Text(
            'Nhấn nút + để thêm giao dịch đầu tiên',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
