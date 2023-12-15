import 'package:flutter/material.dart';

class CaiDatHinhNenScreen extends StatefulWidget {
  const CaiDatHinhNenScreen({super.key});

  @override
  State<CaiDatHinhNenScreen> createState() => _CaiDatHinhNenScreenState();
}

class _CaiDatHinhNenScreenState extends State<CaiDatHinhNenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 55,
          title: const Text("Cài đặt hình nền"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: renderBodyCaiDatHinhNen());
  }

  renderBodyCaiDatHinhNen() {
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
