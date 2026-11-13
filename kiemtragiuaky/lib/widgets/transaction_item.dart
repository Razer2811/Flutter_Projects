import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  String formatMoney(int amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(amount);
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Mua sắm':
        return Icons.shopping_bag;
      case 'Học tập':
        return Icons.school;
      case 'Giải trí':
        return Icons.movie;
      case 'Lương':
        return Icons.account_balance_wallet;
      case 'Thưởng':
        return Icons.card_giftcard;
      case 'Tiền phụ cấp':
        return Icons.payments_outlined;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECE9)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isIncome
                ? const Color(0xFFE8F2EE)
                : const Color(0xFFF9ECEA),
            child: Icon(
              getCategoryIcon(transaction.category),
              color: isIncome
                  ? const Color(0xFF167C63)
                  : const Color(0xFFB85C52),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${transaction.category} • '
                  '${DateFormat('dd/MM/yyyy').format(transaction.createdAt)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${formatMoney(transaction.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome
                      ? const Color(0xFF167C63)
                      : const Color(0xFFB85C52),
                ),
              ),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 19,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
