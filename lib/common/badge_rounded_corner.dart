import 'package:flutter/material.dart';

class BadgeRoundedCornersWidget extends StatelessWidget {
  final Color? borderColor;
  final Color? background;
  final Widget child;
  const BadgeRoundedCornersWidget(
      {super.key, this.borderColor, required this.child, this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        color: background,
      ),
      child: child,
    );
  }
}
