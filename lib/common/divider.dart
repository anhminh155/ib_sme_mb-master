
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key? key,
    this.padding,
  }) : super(key: key);

  /// padding could not be used
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: padding,
      child: const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFEAEBEC),
      ),
    );
  }
}

