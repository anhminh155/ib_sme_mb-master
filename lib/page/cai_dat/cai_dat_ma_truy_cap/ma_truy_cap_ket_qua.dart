import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:intl/intl.dart';

import '../../../common/button.dart';
import '../../../enum/enum.dart';
import '../../../utils/theme.dart';
import 'ma_truy_cap.dart';

class MaTruyCapKetQuaWidget extends StatefulWidget {
  final Cust cust;
  final String type;
  final String codeOTP;
  const MaTruyCapKetQuaWidget(
      {super.key,
      required this.cust,
      required this.type,
      required this.codeOTP});

  @override
  State<MaTruyCapKetQuaWidget> createState() => _MaTruyCapKetQuaWidgetState();
}

class _MaTruyCapKetQuaWidgetState extends State<MaTruyCapKetQuaWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaTruyCapWidget(),
                  ),
                  (route) => route.isFirst,
                );
              },
              icon: const Icon(Icons.arrow_back)),
          toolbarHeight: 55,
          title: Text(widget.type == "edit"
              ? "Chỉnh sửa mã truy cập"
              : "Thêm mới mã truy cập"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                formKetQuaCust(widget.cust),
                const SizedBox(
                  height: 24,
                ),
                ButtonWidget(
                    backgroundColor: secondaryColor,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MaTruyCapWidget(),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    text: "Về quản lý mã giao dịch",
                    colorText: Colors.white,
                    haveBorder: false,
                    widthButton: double.infinity),
              ],
            ),
          ),
        ));
  }

  Widget formKetQuaCust(Cust cust) {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          headerKetQuaCust(),
          rowSpaceBW('Họ và tên', cust.fullname!),
          rowSpaceBW('Loại giấy tờ', cust.indentitypapers!),
          rowSpaceBW('Số giấy tờ', cust.idno!),
          rowSpaceBW(
              'Ngày sinh',
              DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(cust.birthday!).toLocal())),
          rowSpaceBW('Số điện thoại', cust.tel!),
          rowSpaceBW('Email', cust.email!),
          rowSpaceBW(
              'Vai trò',
              cust.position == PositionEnum.QUANTRI.value
                  ? "Quản lý"
                  : cust.position == PositionEnum.LAPLENH.value
                      ? "Mã lập lệnh"
                      : "Mã duyệt lệnh"),
          rowSpaceBW('Mã truy cập', cust.code!),
          rowSpaceBW('Phương thức xác thực',
              cust.verifyType == 1 ? "SMS" : "Smart OTP"),
          rowSpaceBW('Mã giao dịch', widget.codeOTP),
          const Center(
            child: Text(
              "Kết quả sẽ được gửi vào Email của bạn",
              style: TextStyle(
                  color: colorBlack_727374,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowSpaceBW(String label, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: colorBlack_727374,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  Widget headerKetQuaCust() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.done,
              size: 40,
              color: coloreWhite_EAEBEC,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
              widget.type == "edit"
                  ? "Chỉnh sửa mã truy cập thành công"
                  : "Thêm mới mã truy cập thành công",
              style: const TextStyle(
                  color: colorBlack_15334A,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            DateFormat("hh:mm dd-MM-yyyy").format(DateTime.now()).toString(),
            style: const TextStyle(
              color: colorBlack_727374,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
