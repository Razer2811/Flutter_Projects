import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final int balance;
  final int income;
  final int expense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  String formatMoney(int amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(amount);
  }

  Widget buildMoneyInfo(String title, int amount, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatMoney(amount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF167C63),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng số dư',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),

          const SizedBox(height: 10),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatMoney(balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              buildMoneyInfo('Thu nhập', income, Icons.arrow_downward),
              const SizedBox(width: 12),
              buildMoneyInfo('Chi tiêu', expense, Icons.arrow_upward),
            ],
          ),
        ],
      ),
    );
  }
}
