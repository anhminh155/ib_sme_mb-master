import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/theme.dart';

class TextFieldWidget extends StatelessWidget {
  ///
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.readOnly = false,
      this.onTapInput,
      this.suffixText,
      this.suffixIcon,
      this.prefixIcon,
      this.obscureText = false,
      this.validator,
      this.focusNode,
      this.fontSize,
      this.onChange,
      this.onSubmitted,
      this.enabled = true,
      this.textInputType,
      this.inputFormatters,
      this.maxLines,
      this.maxLength,
      this.horizontal})
      : assert((readOnly == true && onTapInput != null) ||
            (readOnly == false && onTapInput == null)),
        super(key: key);

  /// onTap all widget input, onTapInput exist if readOnly == true
  final VoidCallback? onTapInput;

  /// Controller of input
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final int? maxLength;
  final String? suffixText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool enabled;
  final dynamic validator;
  final dynamic focusNode;
  final double? fontSize;
  final double? horizontal;
  final Function? onChange;
  final Function? onSubmitted;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  /// If readOnly equal true, onTapInput must different null
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    FocusNode unUsedFocusNode = FocusNode();
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      minLines: 1,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted!(value);
        }
      },
      readOnly: readOnly,
      onTap: onTapInput,
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).requestFocus(unUsedFocusNode);
      },
      controller: controller,
      validator: validator,
      style: TextStyle(
        color: colorBlack_20262C,
        fontSize: fontSize ?? 16.0,
        overflow: TextOverflow.ellipsis,
      ),
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value);
        }
      },
      focusNode: focusNode,
      cursorColor: Colors.black87,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: colorBlack_727374,
        ),
        hintText: hintText,
        contentPadding: EdgeInsets.only(
            left: 16.0, right: horizontal ?? 16.0, top: 12.0, bottom: 12.0),
        fillColor: Colors.white,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            // color: Color(0xFFC0C2C3),
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
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          color: colorBlack_20262C,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
