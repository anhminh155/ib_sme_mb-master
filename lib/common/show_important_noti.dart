import 'package:flutter/material.dart';

import '../utils/theme.dart';
import 'button.dart';

showImportantNoti(BuildContext context, {required content, required func}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 10), // Đặt độ rộng của content
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Đặt độ cong cho border
        ),
        title: Container(
          width: 50, // Đặt kích thước rộng của container
          height: 50, // Đặt kích thước cao của container
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Đặt hình dạng là hình tròn
            border: Border.all(
              color: Colors.red, // Màu sắc của border
              width: 2.0, // Độ dày của border
            ),
          ),
          child: const Icon(
            Icons.priority_high,
            color: Colors.red,
          ),
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'Đóng',
                    colorText: primaryColor,
                    haveBorder: true,
                    colorBorder: primaryColor,
                    widthButton: MediaQuery.of(context).size.width * .3),
                ButtonWidget(
                    backgroundColor: primaryColor,
                    onPressed: func,
                    text: 'Đồng ý',
                    colorText: Colors.white,
                    haveBorder: false,
                    widthButton: MediaQuery.of(context).size.width * .3),
              ],
            ),
          ),
        ],
      );
    },
  );
}
