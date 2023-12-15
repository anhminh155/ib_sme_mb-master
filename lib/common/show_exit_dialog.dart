import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Đăng xuất",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          content: const Text(
            "Quý khách muốn kết thúc phiên đăng nhập này?",
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  onPressed: () => Navigator.of(context).pop(false),
                  backgroundColor: colorWhite,
                  colorText: secondaryColor,
                  haveBorder: true,
                  colorBorder: secondaryColor,
                  text: 'Không',
                  widthButton: MediaQuery.sizeOf(context).width * .3,
                ),
                ButtonWidget(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  backgroundColor: primaryColor,
                  colorText: colorWhite,
                  haveBorder: false,
                  text: 'Đồng ý',
                  widthButton: MediaQuery.sizeOf(context).width * .3,
                ),
              ],
            ),
          ],
        ),
      ) ??
      false;
}
