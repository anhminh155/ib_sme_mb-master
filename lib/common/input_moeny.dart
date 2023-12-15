import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../utils/theme.dart';

// ignore: must_be_immutable
class InputMoenyWidget extends StatefulWidget {
  late String? value;
  Function? onChange;
  String? hintText;
  final double? horizontal;
  InputMoenyWidget({super.key, this.value, this.onChange, this.horizontal});

  @override
  State<InputMoenyWidget> createState() => _InputMoenyWidgetState();
}

class _InputMoenyWidgetState extends State<InputMoenyWidget> {
  late TextEditingController text;

  final convert = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      text = TextEditingController(
          text: convert.format(int.tryParse(widget.value ?? '')));
    } else {
      text = TextEditingController(text: null);
    }
  }

  @override
  void dispose() {
    super.dispose();
    text.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: colorBlack_727374,
          ),
          hintText: widget.hintText,
          contentPadding: EdgeInsets.only(
              left: 16.0,
              right: widget.horizontal ?? 16.0,
              top: 12.0,
              bottom: 12.0),
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
        ),
        controller: text,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          final newValue = int.tryParse(value.replaceAll(',', ''));
          if (newValue != null) {
            text.value = text.value.copyWith(
              text: convert.format(newValue),
              selection: TextSelection.collapsed(
                  offset: convert.format(newValue).length),
            );
          }
          widget.onChange!(value);
        },
      ),
    );
  }
}
