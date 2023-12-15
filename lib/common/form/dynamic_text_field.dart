import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

class DynamicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Function? onChanged;
  final bool isRequiredNotEmpty;
  final Color? fillColor;
  final int? maxline;
  final int? minline;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? onComplete;
  final bool autofocus;
  final bool readOnly;
  const DynamicTextField({
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isRequiredNotEmpty = false,
    Key? key,
    this.fillColor,
    this.maxline,
    this.keyboardType,
    this.minline,
    this.onComplete,
    this.prefixIcon,
    this.autofocus = false,
    this.readOnly = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readOnly,
      autofocus: autofocus,
      onEditingComplete: onComplete,
      keyboardType: keyboardType,
      inputFormatters: (keyboardType == TextInputType.number)
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      style: const TextStyle(
        color: colorBlack_20262C,
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: maxline,
      minLines: minline,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: fillColor,
        hoverColor: Colors.transparent,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC0C2C3), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
      ),
      onChanged: onChanged != null
          ? (text) {
              onChanged!(text);
            }
          : null,
      validator: (value) {
        if ((value == null || value.isEmpty) && isRequiredNotEmpty) {
          if (keyboardType == TextInputType.number) {
            return "Please enter a number";
          } else {
            return "This field is required!";
          }
        }
        return null;
      },
    );
  }
}
