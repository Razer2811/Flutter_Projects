import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

class StatisticsScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final int totalIncome;
  final int totalExpense;
  final String Function(int amount) formatMoney;

  const StatisticsScreen({
    super.key,
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    final byCategory = <String, int>{};
    for (final item in transactions.where((item) => item.type == 'expense')) {
      byCategory[item.category] =
          (byCategory[item.category] ?? 0) + item.amount;
    }
    final categories = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = categories.isEmpty ? 1 : categories.first.value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        const Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17211D),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tổng quan dòng tiền của bạn',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Thu nhập',
                value: totalIncome,
                color: const Color(0xFF167C63),
                formatMoney: formatMoney,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Chi tiêu',
                value: totalExpense,
                color: const Color(0xFFD86558),
                formatMoney: formatMoney,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'Chi tiêu theo danh mục',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        if (categories.isEmpty)
          const _NoStats()
        else
          ...categories.map(
            (entry) => _CategoryBar(
              category: entry.key,
              amount: entry.value,
              maxValue: maxValue,
              formatMoney: formatMoney,
            ),
          ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final String Function(int) formatMoney;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECE9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatMoney(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String category;
  final int amount;
  final int maxValue;
  final String Function(int) formatMoney;

  const _CategoryBar({
    required this.category,
    required this.amount,
    required this.maxValue,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                formatMoney(amount),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: amount / maxValue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: const Color(0xFFE7EEEA),
            color: const Color(0xFF167C63),
          ),
        ],
      ),
    );
  }
}

class _NoStats extends StatelessWidget {
  const _NoStats();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'Chưa đủ dữ liệu để hiển thị',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
