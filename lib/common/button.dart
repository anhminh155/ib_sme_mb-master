import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    required this.colorText,
    required this.haveBorder,
    required this.widthButton,
    this.colorBorder,
    this.height,
  })  : assert((haveBorder == true && colorBorder != null) ||
            (haveBorder == false && colorBorder == null)),
        super(key: key);

  final Color backgroundColor;
  final VoidCallback? onPressed;
  final String text;
  final Color colorText;
  final bool haveBorder;
  final double widthButton;
  final Color? colorBorder;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40,
      width: widthButton,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: colorBlue_80ACD5,
          alignment: Alignment.center,
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor,
          elevation: 0,
          side: haveBorder
              ? BorderSide(
                  width: 1,
                  color: colorBorder!,
                )
              : null,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: colorText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
