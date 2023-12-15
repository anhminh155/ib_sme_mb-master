import 'package:flutter/material.dart';

class QuanLyDanhBaHoaDonScreen extends StatefulWidget {
  const QuanLyDanhBaHoaDonScreen({super.key});

  @override
  State<QuanLyDanhBaHoaDonScreen> createState() =>
      _QuanLyDanhBaHoaDonScreenState();
}

class _QuanLyDanhBaHoaDonScreenState extends State<QuanLyDanhBaHoaDonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý danh bạ hóa đơn"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: renderBodyQuanLyDanhBaHoaDon(),
          ),
        ],
      ),
    );
  }

  renderBodyQuanLyDanhBaHoaDon() {
    return const Center(
      child: Text(
        "Chức năng đang được cập nhật",
        style: TextStyle(
            color: Colors.black26,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
