// ignore_for_file: non_const_argument_for_const_parameter

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';

const ink = Color(0xFF20211F);
const muted = Color(0xFF777A73);
const paper = Color(0xFFF7F7F3);
const line = Color(0xFFE6E7E0);
const green = Color(0xFF92AA91);
const coral = Color(0xFFDA8B78);

// Dynamic category icons are loaded from SQLite at runtime.
IconData _iconData(int codePoint) =>
    IconData(codePoint, fontFamily: 'MaterialIcons');

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MinimalExpenseApp());
}

class MinimalExpenseApp extends StatelessWidget {
  const MinimalExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tài chính của tôi',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          brightness: Brightness.light,
          surface: paper,
        ),
        fontFamily: 'Roboto',
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: paper,
          foregroundColor: ink,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final bool loadFromDatabase;

  const DashboardScreen({super.key, this.loadFromDatabase = true});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  List<TransactionModel> _transactions = [];
  List<TxCategory> _categories = [];
  Map<int, double> _budgetLimits = {};
  DateTime _budgetMonth = DateTime(DateTime.now().year, DateTime.now().month);
  double _balance = 0;
  double _income = 0;
  double _expense = 0;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    if (widget.loadFromDatabase) _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await DatabaseHelper.instance.getTransactions();
    final categories = await DatabaseHelper.instance.getCategories();
    final budgets = await DatabaseHelper.instance.getBudgets(
      _monthKey(_budgetMonth),
    );
    var income = 0.0;
    var expense = 0.0;
    for (final transaction in transactions) {
      if (transaction.type == 1) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
      _categories = categories;
      _budgetLimits = {
        for (final budget in budgets) budget.categoryId: budget.limit,
      };
      _income = income;
      _expense = expense;
      _balance = income - expense;
    });
  }

  String _monthKey(DateTime month) =>
      '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';

  double _spentInMonth(int categoryId) {
    return _transactions
        .where(
          (transaction) =>
              transaction.categoryId == categoryId &&
              DateTime.fromMillisecondsSinceEpoch(transaction.date).year ==
                  _budgetMonth.year &&
              DateTime.fromMillisecondsSinceEpoch(transaction.date).month ==
                  _budgetMonth.month,
        )
        .fold(0.0, (total, transaction) => total + transaction.amount);
  }

  Future<void> _changeBudgetMonth(int offset) async {
    setState(() {
      _budgetMonth = DateTime(_budgetMonth.year, _budgetMonth.month + offset);
    });
    await _loadData();
  }

  Future<void> _editBudget(TxCategory category) async {
    final controller = TextEditingController(
      text: _budgetLimits[category.id]?.round().toString() ?? '',
    );
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Ngân sách ${category.name}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Hạn mức tháng',
            suffixText: '₫',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null) return;
    await DatabaseHelper.instance.saveBudget(
      BudgetModel(
        categoryId: category.id,
        month: _monthKey(_budgetMonth),
        limit: amount,
      ),
    );
    await _loadData();
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(onSaved: _loadData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [_buildOverview(), _buildTransactions(), _buildBudget()],
        ),
      ),
      floatingActionButton: _tab == 0 || _tab == 1
          ? FloatingActionButton(
              onPressed: _openAddSheet,
              backgroundColor: ink,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 26),
            )
          : null,
      bottomNavigationBar: _buildNavigation(),
    );
  }

  Widget _buildOverview() {
    return RefreshIndicator(
      color: ink,
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          _buildHeader(),
          const SizedBox(height: 28),
          _buildBalanceCard(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Khoản thu',
                  value: _currency.format(_income),
                  icon: Icons.arrow_downward_rounded,
                  color: green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'Khoản chi',
                  value: _currency.format(_expense),
                  icon: Icons.arrow_upward_rounded,
                  color: coral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _sectionTitle('Chi tiêu tuần này', '7 ngày gần nhất'),
          const SizedBox(height: 14),
          Container(
            height: 190,
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: line),
            ),
            child: _WeeklyChart(expense: _expense),
          ),
          const SizedBox(height: 28),
          _sectionTitle('Giao dịch gần đây', 'Xem tất cả'),
          const SizedBox(height: 8),
          if (_transactions.isEmpty)
            const _EmptyState()
          else
            ..._transactions.take(4).map(_transactionTile),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'M',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thứ tư, 12 tháng 6',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              SizedBox(height: 3),
              Text(
                'Xin chào, Minh',
                style: TextStyle(
                  color: ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: 'Thông báo',
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          icon: const Icon(Icons.notifications_none_rounded, color: ink),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Số dư hiện tại',
                style: TextStyle(color: Color(0xFFB7B9B2), fontSize: 13),
              ),
              Spacer(),
              Icon(Icons.more_horiz, color: Color(0xFFB7B9B2)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _currency.format(_balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Text(
                'Đã sử dụng tháng này',
                style: TextStyle(color: Color(0xFFB7B9B2), fontSize: 12),
              ),
              const Spacer(),
              Text(
                _income == 0
                    ? '0%'
                    : '${((_expense / _income) * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _income == 0 ? 0 : (_expense / _income).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: const Color(0xFF454741),
              valueColor: const AlwaysStoppedAnimation(green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 100),
      children: [
        const Text(
          'Giao dịch',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_transactions.length} giao dịch đã ghi nhận',
          style: const TextStyle(color: muted),
        ),
        const SizedBox(height: 26),
        if (_transactions.isEmpty)
          const _EmptyState()
        else
          ..._transactions.map(_transactionTile),
      ],
    );
  }

  Widget _buildBudget() {
    final expenseCategories = _categories.where(
      (category) => category.type == -1,
    );
    final totalSpent = expenseCategories.fold(
      0.0,
      (total, category) => total + _spentInMonth(category.id),
    );
    final totalLimit = _budgetLimits.values.fold(
      0.0,
      (total, limit) => total + limit,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 100),
      children: [
        const Text(
          'Ngân sách',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Đặt hạn mức và theo dõi chi tiêu hằng tháng',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            IconButton(
              onPressed: () => _changeBudgetMonth(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Center(
                child: Text(
                  DateFormat('MM/yyyy').format(_budgetMonth),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _changeBudgetMonth(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: _BudgetSummary(
                  label: 'Đã chi',
                  value: _currency.format(totalSpent),
                  color: coral,
                ),
              ),
              Expanded(
                child: _BudgetSummary(
                  label: 'Hạn mức',
                  value: totalLimit == 0
                      ? 'Chưa đặt'
                      : _currency.format(totalLimit),
                  color: green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Hạn mức theo danh mục',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (expenseCategories.isEmpty)
          const _EmptyState()
        else
          ...expenseCategories.map((category) {
            final spent = _spentInMonth(category.id);
            final limit = _budgetLimits[category.id] ?? 0;
            return _BudgetRow(
              label: category.name,
              icon: _iconData(category.iconCode),
              spent: spent,
              limit: limit,
              color: limit > 0 && spent > limit ? coral : green,
              onTap: () => _editBudget(category),
            );
          }),
      ],
    );
  }

  Widget _sectionTitle(String title, String action) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton(
          onPressed: action == 'Xem tất cả'
              ? () => setState(() => _tab = 1)
              : null,
          child: Text(
            action,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _transactionTile(TransactionModel transaction) {
    final isIncome = transaction.type == 1;
    final icon = _iconData(transaction.categoryIcon ?? 0xe3ab);
    final date = DateTime.fromMillisecondsSinceEpoch(transaction.date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFFE8F0E7)
                  : const Color(0xFFF3E7E2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isIncome
                  ? const Color(0xFF5D805D)
                  : const Color(0xFFAD6858),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName ?? 'Khác',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                if (transaction.note != null && transaction.note!.isNotEmpty)
                  Text(
                    transaction.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}${_currency.format(transaction.amount)}',
            style: TextStyle(
              color: isIncome ? const Color(0xFF527A50) : ink,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (index) => setState(() => _tab = index),
      backgroundColor: Colors.white,
      elevation: 0,
      indicatorColor: const Color(0xFFE9EEE7),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.space_dashboard_outlined),
          selectedIcon: Icon(Icons.space_dashboard),
          label: 'Tổng quan',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Giao dịch',
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_outline),
          selectedIcon: Icon(Icons.pie_chart),
          label: 'Ngân sách',
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final double spent;
  final double limit;
  final Color color;
  final VoidCallback? onTap;

  const _BudgetRow({
    required this.label,
    required this.icon,
    required this.spent,
    required this.limit,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = limit <= 0 ? 0.0 : (spent / limit).clamp(0.0, 1.0);
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: line),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  currency.format(spent),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  limit <= 0 ? ' / Chưa đặt' : ' / ${currency.format(limit)}',
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.edit_outlined, size: 16, color: muted),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 7,
                backgroundColor: const Color(0xFFECEDE8),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetSummary extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BudgetSummary({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB7B9B2), fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final double expense;
  const _WeeklyChart({required this.expense});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartPainter(expense: expense),
      child: const SizedBox.expand(),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final double expense;
  _ChartPainter({required this.expense});

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFEFF0EC)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = 16 + i * (size.height - 42) / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final values = [0.35, 0.52, 0.3, 0.7, 0.48, 0.84, 0.58];
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final y = 22 + (size.height - 62) * (1 - values[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height - 30)
      ..lineTo(0, size.height - 30)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = green.withValues(alpha: .12));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF769773)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    for (var i = 0; i < labels.length; i++) {
      final x = i * size.width / (labels.length - 1);
      final text = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(color: muted, fontSize: 11),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(x - text.width / 2, size.height - 20));
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.expense != expense;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: muted, size: 34),
          SizedBox(height: 12),
          Text(
            'Chưa có giao dịch',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            'Nhấn dấu + để ghi lại khoản đầu tiên',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class AddTransactionSheet extends StatefulWidget {
  final Future<void> Function() onSaved;
  const AddTransactionSheet({super.key, required this.onSaved});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TxCategory> _categories = [];
  TxCategory? _selectedCategory;
  int _type = -1;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await DatabaseHelper.instance.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = categories
          .where((category) => category.type == _type)
          .toList();
      _selectedCategory = _categories.isEmpty ? null : _categories.first;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) return;
    setState(() => _saving = true);
    final amount = double.parse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    await DatabaseHelper.instance.insertTransaction(
      TransactionModel(
        amount: amount,
        categoryId: _selectedCategory!.id,
        date: DateTime.now().millisecondsSinceEpoch,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
    await widget.onSaved();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: line,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Thêm giao dịch',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _typeButton('Khoản chi', -1)),
                    const SizedBox(width: 10),
                    Expanded(child: _typeButton('Khoản thu', 1)),
                  ],
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) =>
                      value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == 0
                      ? 'Nhập số tiền hợp lệ'
                      : null,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Số tiền',
                    suffixText: '₫',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: ink),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _noteController,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú (không bắt buộc)',
                    hintText: 'Ví dụ: Ăn trưa với đồng nghiệp',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Danh mục',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: _categories.map((category) {
                    final selected = category.id == _selectedCategory?.id;
                    return ChoiceChip(
                      label: Text(category.name),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                      avatar: Icon(_iconData(category.iconCode), size: 17),
                      selectedColor: ink,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : ink,
                        fontSize: 12,
                      ),
                      side: BorderSide(color: selected ? ink : line),
                      backgroundColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Lưu giao dịch',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String label, int type) {
    final selected = _type == type;
    return OutlinedButton(
      onPressed: () {
        setState(() => _type = type);
        _loadCategories();
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        backgroundColor: selected
            ? (type == -1 ? const Color(0xFFF3E7E2) : const Color(0xFFE8F0E7))
            : Colors.white,
        side: BorderSide(color: selected ? (type == -1 ? coral : green) : line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ink,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
