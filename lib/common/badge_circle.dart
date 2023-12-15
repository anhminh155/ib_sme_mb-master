import 'package:flutter/material.dart';

class BadgeCircleWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  const BadgeCircleWidget(
      {super.key, required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: backgroundColor,
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
