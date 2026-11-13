import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../widgets/transaction_item.dart';

class HistoryScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Future<void> Function(int id) onDelete;

  const HistoryScreen({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        const Text(
          'Giao dịch',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17211D),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${transactions.length} giao dịch đã ghi nhận',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 22),
        if (transactions.isEmpty)
          const _EmptyHistory()
        else
          ...transactions.map(
            (transaction) => TransactionItem(
              transaction: transaction,
              onDelete: () => onDelete(transaction.id!),
            ),
          ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 14),
          const Text(
            'Chưa có giao dịch',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Thêm giao dịch đầu tiên bằng nút +',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
