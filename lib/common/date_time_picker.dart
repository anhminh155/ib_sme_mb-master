import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:intl/intl.dart';

class DateTimePickerWidget extends StatelessWidget {
  final String? hintText;
  final dynamic controllerDateTime;
  final bool disable;
  final dynamic validator;
  final DateTime? minTime;
  final DateTime? maxTime;
  final Function(DateTime)? onConfirm;
  const DateTimePickerWidget(
      {super.key,
      this.hintText,
      this.controllerDateTime,
      this.disable = false,
      this.minTime,
      this.maxTime,
      this.validator,
      this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: !disable
          ? () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: minTime ?? DateTime(1970, 1, 1),
                maxTime: maxTime ?? DateTime.now(),
                onChanged: (date) {},
                onConfirm: (date) {
                  onConfirm!(date);
                },
                currentTime: controllerDateTime.text.isNotEmpty
                    ? DateFormat('dd/MM/yyyy').parse(controllerDateTime.text)
                    : null,
                locale: LocaleType.vi,
              );
            }
          : null,
      validator: validator,
      readOnly: true,
      controller: controllerDateTime,
      decoration: inputDecorationScreen(
          hintText: hintText,
          suffixIcon: const Icon(Icons.calendar_month_outlined)),
    );
  }

  inputDecorationScreen({hintText, suffixText, suffixIcon}) => InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: colorBlack_727374,
        ),
        hintText: hintText,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 5, 12),
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
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
        suffixIconConstraints:
            const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
      );
}
