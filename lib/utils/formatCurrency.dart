// ignore_for_file: file_names

import 'package:intl/intl.dart';

import '../main.dart';

class Currency {
  static String formatCurrency(dynamic amount) {
    if (amount != null && amount != '') {
      final convert = NumberFormat("#,### VND", "en_US");
      if (amount is String) {
        var amouts = int.tryParse(amount);
        return convert.format(amouts);
      }
      return convert.format(amount);
    }
    return '';
  }

  static String formatNumber(dynamic amount) {
    if (amount != null && amount != '') {
      final convert = NumberFormat("#,###", "en_US");
      return convert.format(amount);
    }
    return '';
  }

  static String numberToWords(int number) {
    String words = '';
    String languageCode = localStorage.getItem('language_code') ?? "VI";
    if (languageCode.toUpperCase().compareTo("EN") == 0) {
      words = numberToWordsEN(number);
      return "${words[0].toUpperCase()}${words.substring(1).trim()} dong";
    }
    words = numberToWordsVN(number);
    return "${words[0].toUpperCase()}${words.substring(1).trim()} đồng";
  }

  static String removeFormatNumber(String value) {
    if (value.contains(',')) {
      return value.replaceAll(',', '');
    } else {
      return value;
    }
  }

  static String numberToWordsVN(int number) {
    if (number == 0) {
      return 'Không đồng';
    }
    if (number < 0) {
      return 'Âm ${numberToWordsVN(-number)} đồng';
    }
    String words = '';
    List<String> unitsWords = [
      '',
      'một',
      'hai',
      'ba',
      'bốn',
      'năm',
      'sáu',
      'bảy',
      'tám',
      'chín'
    ];
    List<String> tensWords = [
      '',
      'mười',
      'hai mươi',
      'ba mươi',
      'bốn mươi',
      'năm mươi',
      'sáu mươi',
      'bảy mươi',
      'tám mươi',
      'chín mươi'
    ];
    List<String> thousandsWords = [
      '',
      'nghìn',
      'triệu',
      'tỷ',
      'nghìn tỷ',
      'triệu tỷ',
      'nghìn triệu tỷ'
    ];
    int thousandsIndex = 0;
    while (number > 0) {
      int group = number % 1000;
      int hundreds = group ~/ 100;
      int tens = (group % 100) ~/ 10;
      int units = group % 10;
      String groupWords = '';
      if (hundreds > 0) {
        groupWords += '${unitsWords[hundreds]} trăm';
        if (tens > 0 || units > 0) {
          groupWords += ' ';
        }
      }
      if (tens >= 2) {
        groupWords += tensWords[tens];
        if (units > 0) {
          groupWords += ' ${unitsWords[units]}';
        }
      } else if (tens == 1) {
        if (units > 0) {
          groupWords += 'mười ${unitsWords[units]}';
        } else {
          groupWords += 'mười';
        }
      } else if (units > 0) {
        groupWords += unitsWords[units];
      }
      if (group != 0) {
        groupWords += ' ${thousandsWords[thousandsIndex]}';
      }
      words = '$groupWords $words';
      thousandsIndex++;
      number ~/= 1000;
    }
    return words.trim();
  }

  static String numberToWordsEN(int number) {
    if (number == 0) {
      return 'Zero';
    }

    final List<String> units = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];

    final List<String> tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];

    String words = '';

    if (number >= 1000) {
      words += '${numberToWordsEN(number ~/ 1000)} thousand ';
      number %= 1000;
    }

    if (number >= 100) {
      words += '${numberToWordsEN(number ~/ 100)} hundred ';
      number %= 100;
    }

    if (number > 0) {
      if (words.isNotEmpty) {
        words += 'and ';
      }

      if (number < 20) {
        words += units[number];
      } else {
        words += tens[number ~/ 10];
        if (number % 10 > 0) {
          words += '-${units[number % 10]}';
        }
      }
    }
    return words.trim();
  }
}
