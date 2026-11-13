import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../models/category.dart';
import '../models/txn.dart';
import 'cat_disc.dart';

class TxnRow extends StatelessWidget {
  final Txn txn;
  const TxnRow({required this.txn, super.key});

  @override
  Widget build(BuildContext context) {
    final c = catOf(txn.cat);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CatDisc(c),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.note.isEmpty ? c.name : txn.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ts(14, w: FontWeight.w500),
                ),
                if (txn.note.isNotEmpty) Text(c.name, style: ts(12, c: muted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${txn.income ? '+' : '−'}${vnd(txn.amount)} ₫',
            style: ts(14, w: FontWeight.w600, c: txn.income ? pos : ink),
          ),
        ],
      ),
    );
  }
}
