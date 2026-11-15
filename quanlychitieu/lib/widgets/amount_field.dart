import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/format.dart';
import '../core/theme.dart';

class _Thousands extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue();
    if (digits.length > 12) return oldValue;
    final text = vnd(int.parse(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final VoidCallback onChanged;

  const AmountField({
    required this.controller,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Số tiền', style: ts(14, c: muted)),
        TextField(
          controller: controller,
          autofocus: autofocus,
          keyboardType: TextInputType.number,
          inputFormatters: [_Thousands()],
          onChanged: (_) => onChanged(),
          style: ts(36, w: FontWeight.w600),
          cursorColor: ink,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: ts(36, w: FontWeight.w600, c: const Color(0xFF9AA0A6)),
            suffixText: '₫',
            suffixStyle: ts(18, c: muted),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        const Divider(height: 1, color: line),
      ],
    );
  }
}
