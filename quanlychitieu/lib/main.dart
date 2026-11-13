import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'models/category.dart';
import 'models/txn.dart';
import 'widgets/txn_row.dart';
import 'data/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: buildTheme(), home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Txn> items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final r = await Db.month(DateTime.now());
    if (mounted) {
      setState(() {
        items = r;
      });
    }
  }

  Future<void> addTransaction() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _TransactionForm(),
    );
    if (saved == true) {
      await load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addTransaction,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Sổ chi tiêu', style: ts(24, w: FontWeight.w600)),
            const SizedBox(height: 16),
            for (final t in items) TxnRow(txn: t),
          ],
        ),
      ),
    );
  }
}

class _TransactionForm extends StatefulWidget {
  const _TransactionForm();

  @override
  State<_TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<_TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _income = false;
  String _category = 'food';
  DateTime _date = DateTime.now();
  bool _saving = false;

  List<Cat> get _availableCategories =>
      cats.where((category) => category.income == _income).toList();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() => _date = selected);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (amount == null || amount <= 0) {
      _formKey.currentState!.validate();
      return;
    }

    setState(() => _saving = true);
    try {
      await Db.save(
        Txn(
          amount: amount,
          income: _income,
          cat: _category,
          note: _noteController.text.trim(),
          date: _date,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu dữ liệu: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final categories = _availableCategories;
    if (!categories.any((category) => category.id == _category)) {
      _category = categories.first.id;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Thêm giao dịch', style: ts(20, w: FontWeight.w600)),
              const SizedBox(height: 16),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Chi')),
                  ButtonSegment(value: true, label: Text('Thu')),
                ],
                selected: {_income},
                onSelectionChanged: _saving
                    ? null
                    : (selected) => setState(() {
                        _income = selected.first;
                        _category = _availableCategories.first.id;
                      }),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  suffixText: '₫',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final amount = int.tryParse(
                    (value ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
                  );
                  if (amount == null || amount <= 0) {
                    return 'Nhập số tiền lớn hơn 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) setState(() => _category = value);
                      },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú (không bắt buộc)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _saving ? null : _selectDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  'Ngày: ${_date.day.toString().padLeft(2, '0')}/'
                  '${_date.month.toString().padLeft(2, '0')}/${_date.year}',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Lưu giao dịch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
