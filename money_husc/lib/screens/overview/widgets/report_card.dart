import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class ReportCard extends StatefulWidget {
  final String spent;
  final String income;

  const ReportCard({required this.spent, required this.income, super.key});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  int _tab = 0; // 0 = chi, 1 = thu

  Widget _tabItem(int index, String label, String value, Color color) {
    final selected = _tab == index;
    return InkWell(
      onTap: () => setState(() => _tab = index),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.grey, fontSize: 17),
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 22)),
          const SizedBox(height: 12),
          Container(height: 3, color: selected ? color : AppColors.line),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _tabItem(0, 'Tổng đã chi', widget.spent, AppColors.red),
              ),
              Expanded(
                child: _tabItem(1, 'Tổng thu', widget.income, AppColors.blue),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Text(
                    'Nhập giao dịch để xem báo cáo',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('0', style: TextStyle(color: AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
