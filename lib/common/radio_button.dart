import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

// ignore: must_be_immutable
class RadioButtonWidget extends StatefulWidget {
  final dynamic value;
  dynamic group;
  final String title;
  RadioButtonWidget(
      {super.key,
      required this.value,
      required this.group,
      required this.title});

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(widget.title),
      activeColor: primaryColor,
      value: widget.value,
      groupValue: widget.group,
      onChanged: (val) {
        setState(() {
          widget.group = val;
        });
      },
    );
  }
}
