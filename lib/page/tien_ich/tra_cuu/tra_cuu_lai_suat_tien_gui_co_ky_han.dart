import 'package:flutter/material.dart';

class TraCuuLaiSuatTienGuiCoKyHanScreen extends StatefulWidget {
  const TraCuuLaiSuatTienGuiCoKyHanScreen({super.key});

  @override
  State<TraCuuLaiSuatTienGuiCoKyHanScreen> createState() =>
      _TraCuuLaiSuatTienGuiCoKyHanScreenState();
}

class _TraCuuLaiSuatTienGuiCoKyHanScreenState
    extends State<TraCuuLaiSuatTienGuiCoKyHanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tra cứu lãi suất tiền gửi có kỳ hạn"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: renderBodyTraCuuLaiSuatTienGuiCoKyHan(),
        ),
      ),
    );
  }

  renderBodyTraCuuLaiSuatTienGuiCoKyHan() {
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
