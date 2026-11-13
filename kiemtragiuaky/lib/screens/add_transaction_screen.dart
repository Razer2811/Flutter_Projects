import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = 'expense';
  String category = 'Ăn uống';

  final expenseCategories = [
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Học tập',
    'Giải trí',
    'Khác',
  ];

  final incomeCategories = ['Lương', 'Thưởng', 'Tiền phụ cấp', 'Khác'];

  Future<void> saveTransaction() async {
    final title = titleController.text.trim();
    final amount = int.tryParse(amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập thông tin hợp lệ!')),
      );
      return;
    }

    final transaction = TransactionModel(
      title: title,
      amount: amount,
      type: type,
      category: category,
      note: noteController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await DatabaseHelper.instance.insertTransaction(transaction);
    } on DatabaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu giao dịch: $error')),
      );
      return;
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loại giao dịch
            Row(
              children: [
                Expanded(child: typeButton('expense', 'Chi tiêu')),
                const SizedBox(width: 12),
                Expanded(child: typeButton('income', 'Thu nhập')),
              ],
            ),

            const SizedBox(height: 25),

            // Tên giao dịch
            const Text(
              'Tên giao dịch',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              decoration: inputDecoration('Ví dụ: Ăn sáng, tiền lương...'),
            ),

            const SizedBox(height: 22),

            // Số tiền
            const Text(
              'Số tiền (VNĐ)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration('Nhập số tiền').copyWith(
                suffixText: 'VNĐ',
                suffixStyle: const TextStyle(
                  color: Color(0xFF167C63),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Danh mục
            const Text(
              'Danh mục',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: category,
              decoration: inputDecoration('Chọn danh mục'),
              items: (type == 'expense' ? expenseCategories : incomeCategories)
                  .map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  })
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),

            const SizedBox(height: 22),

            // Ghi chú
            const Text(
              'Ghi chú (tùy chọn)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: inputDecoration('Thêm ghi chú...'),
            ),

            const SizedBox(height: 35),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: saveTransaction,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF167C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lưu giao dịch',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeButton(String value, String label) {
    final selected = type == value;

    return FilledButton(
      onPressed: () {
        setState(() {
          type = value;
          category = value == 'expense' ? 'Ăn uống' : 'Lương';
        });
      },
      style: FilledButton.styleFrom(
        backgroundColor: selected
            ? const Color(0xFF167C63)
            : Colors.grey.shade200,
        foregroundColor: selected ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}
