// ignore_for_file: file_names

import 'package:intl/intl.dart';

String convertDateTimeFormat(String inputFormat) {
  if (inputFormat.isNotEmpty) {
    DateTime dateTime = DateTime.parse(inputFormat).toLocal();
    final DateFormat formatter = DateFormat('HH:mm:ss dd/MM/yyyy', 'vi_VN');
    final String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }
  return "";
}

String convertDateFormat(String? inputFormat, {bool time = false}) {
  if (inputFormat != null) {
    String formatValue = time ? 'dd/MM/yyyy HH:mm:ss' : 'dd/MM/yyyy';
    DateTime dateTime = DateTime.parse(inputFormat).toLocal();
    final DateFormat formatter = DateFormat(formatValue, 'vi_VN');
    final String formattedDateTime = formatter.format(dateTime);
    return formattedDateTime;
  }
  return "_ _ _ _ _";
}

String formatDateString({required String value}) {
  if (value.isNotEmpty) {
    final formatter = DateFormat('MM/dd/yyyy');
    if (value.isNotEmpty) {
      return formatter.format(DateFormat('dd/MM/yyyy').parse(value));
    }
  }
  return '';
}
