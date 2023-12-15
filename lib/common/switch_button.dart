import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../utils/theme.dart';

class SwitchButtonWidget extends StatelessWidget {
  final String title;
  final Function callback;
  final bool status;
  final TextStyle? style;
  final bool disabled;
  const SwitchButtonWidget(
      {super.key,
      required this.title,
      required this.callback,
      required this.status,
      this.style,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: style ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          FlutterSwitch(
            activeColor: disabled
                ? colorGreen_56AB01.withOpacity(0.3)
                : colorGreen_56AB01,
            inactiveColor:
                disabled ? Colors.grey.withOpacity(0.3) : Colors.grey,
            width: 40,
            height: 21,
            toggleSize: 20,
            value: status,
            borderRadius: 20,
            padding: 1,
            onToggle: (val) {
              callback(status);
            },
            disabled: disabled,
          ),
        ]);
  }
}
