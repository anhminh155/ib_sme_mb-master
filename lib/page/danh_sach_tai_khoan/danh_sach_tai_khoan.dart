import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

class DanhSachTaiKhoanPageWidget extends StatefulWidget {
  const DanhSachTaiKhoanPageWidget({super.key});

  @override
  State<DanhSachTaiKhoanPageWidget> createState() =>
      _DanhSachTaiKhoanPageWidgetState();
}

class _DanhSachTaiKhoanPageWidgetState
    extends State<DanhSachTaiKhoanPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        toolbarHeight: 84,
        centerTitle: true,
        title: const Text("Danh sách tài khoản"),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              children: [
                cardItem(
                  title: "Tài khoản thanh toán",
                  subTitle: "Tổng số dư: 500,000,000 VNĐ",
                  quantity: "3",
                ),
                const SizedBox(
                  height: 24,
                ),
                cardItem(
                  title: "Tiền gửi có kì hạn",
                  subTitle: "Tổng số dư: 400,000,000 VNĐ",
                  quantity: "3",
                ),
                const SizedBox(
                  height: 24,
                ),
                cardItem(
                  title: "Tiền gửi không kỳ hạn",
                  subTitle: "Tổng số dư: 80,000,000 VNĐ",
                  quantity: "3",
                ),
                const SizedBox(
                  height: 24,
                ),
                cardItem(
                  title: "Tài khoản tiền vay",
                  subTitle: "Tổng số dư: 80,000,000 VNĐ",
                  quantity: "3",
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardItem(
      {required String title,
      required String subTitle,
      required String quantity}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(151, 156, 168, 0.16),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorBlack_727374,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "$quantity tài khoản",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
