import 'package:flutter/material.dart';

class TaoTenGoiNhoScreen extends StatefulWidget {
  const TaoTenGoiNhoScreen({super.key});

  @override
  State<TaoTenGoiNhoScreen> createState() => _TaoTenGoiNhoScreenState();
}

class _TaoTenGoiNhoScreenState extends State<TaoTenGoiNhoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo tên gợi nhớ"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: renderBodyTaoTenGoiNho(),
        ),
      ),
    );
  }

  renderBodyTaoTenGoiNho() {
    return const Text(
      "Chức năng đang được cập nhật",
      style: TextStyle(
          color: Colors.black26,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic),
    );
  }
}
