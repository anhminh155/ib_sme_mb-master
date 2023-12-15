import 'package:flutter/material.dart';

class TraCuuTyGiaNgoaiTeScreen extends StatefulWidget {
  const TraCuuTyGiaNgoaiTeScreen({super.key});

  @override
  State<TraCuuTyGiaNgoaiTeScreen> createState() =>
      _TraCuuTyGiaNgoaiTeScreenState();
}

class _TraCuuTyGiaNgoaiTeScreenState extends State<TraCuuTyGiaNgoaiTeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tra cứu tỷ giá ngoại tệ"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: renderBodyTraCuuTyGiaNgoaiTe(),
        ),
      ),
    );
  }

  renderBodyTraCuuTyGiaNgoaiTe() {
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
