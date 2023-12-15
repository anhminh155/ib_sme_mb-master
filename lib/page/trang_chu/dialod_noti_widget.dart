import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

renderDialog(context, title) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shadowColor: Colors.black,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo1.svg',
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Thông báo",
                        style: TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 22,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Text(
                    title,
                    style: const TextStyle(height: 1.6),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
