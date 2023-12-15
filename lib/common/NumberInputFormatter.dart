// ignore_for_file: file_names

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final cleanValue = newValue.text.replaceAll(',', '');

    final formattedValue = _formatNumber(cleanValue);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatNumber(String value) {
    final number = int.tryParse(value);
    if (number != null) {
      final formatter = NumberFormat("#,###");
      return formatter.format(number);
    }
    return value;
  }
}
