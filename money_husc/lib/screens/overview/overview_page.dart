import 'package:flutter/material.dart';

import 'widgets/balance_header.dart';
import 'widgets/wallet_card.dart';
import '../../widgets/section_header.dart';
import 'widgets/report_card.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          BalanceHeader(
            balance: '0 đ',
            hidden: _hidden,
            onToggle: () => setState(() => _hidden = !_hidden),
          ),
          const SizedBox(height: 24),
          const WalletCard(name: 'Bun', balance: '0 đ'),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Báo cáo tháng này',
            action: 'Xem báo cáo',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          const ReportCard(spent: '0', income: '0'),
        ],
      ),
    );
  }
}
