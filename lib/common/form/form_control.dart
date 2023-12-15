import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

class FormControlWidget extends StatelessWidget {
  final String? label;
  final Widget? child;
  const FormControlWidget({super.key, this.label, this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              color: colorBlack_727374,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (child != null)
          Padding(
            padding: EdgeInsets.only(top: label != null ? 6 : 0),
            child: child,
          )
      ],
    );
  }
}
