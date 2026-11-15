import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../data/database.dart';
import '../models/category.dart';
import '../models/txn.dart';
import '../widgets/amount_field.dart';
import '../widgets/category_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool income = false;
  String cat = 'food';
  DateTime date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final amount = TextEditingController();
  final note = TextEditingController();

  bool get valid => amount.text.isNotEmpty;

  @override
  void dispose() {
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() {
        date = d;
      });
    }
  }

  Future<void> save() async {
    await Db.save(
      Txn(
        amount: parseVnd(amount.text),
        income: income,
        cat: cat,
        note: note.text.trim(),
        date: date,
      ),
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giao dịch mới', style: ts(18, w: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            typeToggle(),
            const SizedBox(height: 28),
            AmountField(
              controller: amount,
              autofocus: true,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text('Danh mục', style: ts(14, c: muted)),
            const SizedBox(height: 12),
            CategoryPicker(
              income: income,
              selected: cat,
              onSelect: (id) => setState(() => cat = id),
            ),
            const SizedBox(height: 24),
            Text('Ghi chú', style: ts(14, c: muted)),
            const SizedBox(height: 8),
            noteField(),
            const SizedBox(height: 20),
            Text('Ngày', style: ts(14, c: muted)),
            const SizedBox(height: 8),
            dateField(),
            const SizedBox(height: 32),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget typeToggle() {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<bool>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: false, label: Text('Chi tiêu')),
          ButtonSegment(value: true, label: Text('Thu nhập')),
        ],
        selected: {income},
        onSelectionChanged: (s) {
          setState(() {
            income = s.first;
            cat = cats.firstWhere((c) => c.income == income).id;
          });
        },
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: ink,
          selectedForegroundColor: Colors.white,
          foregroundColor: ink,
          side: const BorderSide(color: line),
        ),
      ),
    );
  }

  Widget noteField() {
    return TextField(
      controller: note,
      style: ts(14),
      cursorColor: ink,
      decoration: InputDecoration(
        hintText: 'Ví dụ: Cà phê với bạn',
        hintStyle: ts(14, c: const Color(0xFF6B6B6B)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ink, width: 1.5),
        ),
      ),
    );
  }

  Widget dateField() {
    return InkWell(
      onTap: pickDate,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(dmy(date), style: ts(14)),
            const Spacer(),
            const Icon(Icons.calendar_today_outlined, size: 18, color: muted),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: valid ? save : null,
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          disabledBackgroundColor: chip,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Lưu',
          style: ts(15, w: FontWeight.w600, c: valid ? Colors.white : muted),
        ),
      ),
    );
  }
}
