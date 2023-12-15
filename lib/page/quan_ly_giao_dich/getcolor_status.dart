import 'package:flutter/material.dart';

import '../../../utils/theme.dart';

Color getColorByValue(String value) {
  Color color;

  switch (value.toLowerCase()) {
    case 'đã duyệt':
      color = primaryColor;
      break;
    case 'thành công':
      color = Colors.green;
      break;
    case 'hoàn thành':
      color = Colors.green;
      break;
    case 'hủy':
      color = Colors.red.shade900;
      break;
    case 'từ chối':
      color = Colors.red.shade900;
      break;
    case 'không thành công':
      color = secondaryColor;
      break;
    case 'lỗi':
      color = Colors.red.shade500;
      break;
    case 'chờ xử lý':
      color = const Color(0xFFFF6600);
      break;
    case 'chờ duyệt':
      color = const Color(0xFFFF6600);
      break;
    case 'chưa thực hiện':
      color = const Color(0xff666666);
      break;
    default:
      color = Colors.black;
      break;
  }

  return color;
}
