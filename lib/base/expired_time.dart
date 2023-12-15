import 'package:flutter/material.dart';

class ExpiredTimeWidget extends StatelessWidget {
  const ExpiredTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.all(30),
      child: const Text("ExpiredTimeWidget"),
    );
  }
}
