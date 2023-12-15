import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

import '../../../../common/button.dart';

class XacNhanQuyenRutTienGuiOnlineWidget extends StatefulWidget {
  final Cust cust;
  const XacNhanQuyenRutTienGuiOnlineWidget({
    super.key,
    required this.cust,
  });

  @override
  State<XacNhanQuyenRutTienGuiOnlineWidget> createState() =>
      _XacNhanQuyenRutTienGuiOnlineWidgetState();
}

class _XacNhanQuyenRutTienGuiOnlineWidgetState
    extends State<XacNhanQuyenRutTienGuiOnlineWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          toolbarHeight: 55,
          title: const Text("Xác nhận quyền rút tiền gửi Online"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Wrap(
              runSpacing: 16,
              children: [custView(), dichVuVaMaDuyetLenh(), renderButton()],
            ),
          ),
        ));
  }

  custView() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Mã truy cập"),
              Text(
                widget.cust.code ?? "",
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Vai trò"),
              Text(
                widget.cust.position == PositionEnum.LAPLENH.value
                    ? "Mã lập lệnh"
                    : "Mã duyệt lệnh",
                style: const TextStyle(
                  color: primaryBlackColor,
                  //  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Họ và tên"),
              Text(widget.cust.fullname ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Số điện thoại"),
              Text(widget.cust.tel ?? "",
                  style: const TextStyle(color: primaryBlackColor)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Quyền truy cập"),
              Text(
                "Quyền giao dịch",
                style: TextStyle(
                  color: primaryBlackColor,
                  //  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget dichVuVaMaDuyetLenh() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          const Text(
            "Quyền rút tiền gửi online",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          renderRowContent(
              title: "Tài khoản tiền gửi Online",
              custAccList: [
                "0300123456785",
                "0300123456784",
                "0300123456783",
                "0300123456782",
                "0300123456781"
              ],
              isFontWeight: true),
          renderRowContent(
            title: "Mã duyệt lệnh",
            custAccList: ["0123456789DL01", "0123456789DL02"],
          ),
          // for (var chuyenTien in widget.listChuyenTien)
          //   renderRowContent(
          //       title: chuyenTien["title"],
          //       custCodeList: widget.cust.custProduct!
          //               .firstWhere((element) =>
          //                   element.product == chuyenTien["product"])
          //               .custCode ??
          //           "---"),
          // for (var thanhToan in widget.listThanhToan)
          //   renderRowContent(
          //       title: thanhToan["title"],
          //       custCodeList: widget.cust.custProduct!
          //               .firstWhere((element) =>
          //                   element.product == thanhToan["product"])
          //               .custCode ??
          //           "---")
        ],
      ),
    );
  }

  renderRowContent(
      {required String title,
      required List<String> custAccList,
      isFontWeight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                color: colorBlack_727374,
                fontWeight: isFontWeight ? FontWeight.w600 : null),
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var acc in custAccList) Text(acc),
          ],
        )
      ],
    );
  }

  Widget renderButton() {
    return Column(
      children: [
        ButtonWidget(
            backgroundColor: secondaryColor,
            onPressed: () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const CapNhatQuyenGiaoDichScreen(),
              //   ),
              // );
            },
            text: translation(context)!.continueKey,
            colorText: Colors.white,
            haveBorder: false,
            widthButton: double.infinity),
        const SizedBox(
          height: 12,
        ),
        ButtonWidget(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            text: translation(context)!.backKey,
            colorText: colorBlack_727374,
            haveBorder: true,
            colorBorder: colorBlack_727374.withOpacity(0.5),
            widthButton: double.infinity),
      ],
    );
  }
}
