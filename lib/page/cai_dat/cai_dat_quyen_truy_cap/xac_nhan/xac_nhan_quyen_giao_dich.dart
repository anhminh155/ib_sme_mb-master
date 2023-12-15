// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_quyen_truy_cap/cai_dat_quyen_truy_cap_chi_tiet.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import '../../../../common/button.dart';
import '../../../../common/show_dialog_otp.dart';
import '../../../../common/show_toast.dart';
import '../../../../network/services/cus_service.dart';
import '../../../../network/services/get_code_gen_otp_service.dart';

class XacNhanQuyenGiaoDichWidget extends StatefulWidget {
  final Cust cust;
  final List listChuyenTien;
  final List listThanhToan;
  const XacNhanQuyenGiaoDichWidget({
    super.key,
    required this.cust,
    required this.listChuyenTien,
    required this.listThanhToan,
  });

  @override
  State<XacNhanQuyenGiaoDichWidget> createState() =>
      _XacNhanQuyenGiaoDichWidgetState();
}

class _XacNhanQuyenGiaoDichWidgetState
    extends State<XacNhanQuyenGiaoDichWidget> {
  getQuanLyMaTruyCapCode(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.QUANLYQUYENTRUYCAP, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    }
  }

  updateQuyenGiaoDichCust(requestBody) async {
    BaseResponse response =
        await CusService().updateQuyenGiaoDichCust(requestBody);
    if (response.errorCode == FwError.THANHCONG.value) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.done));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => CaiDatQuyenTruyCapChiTietScreen(
                    custId: widget.cust.id!,
                    companyType: widget.cust.company!.approveType!,
                  )),
          (route) => route.settings.name == '/page1');
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          toolbarHeight: 55,
          title: const Text("Xác nhận quyền giao dịch"),
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
              children: [
                custView(),
                taiKhoanThanhToan(),
                dichVuVaMaDuyetLenh(),
                renderButton()
              ],
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

  Widget taiKhoanThanhToan() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          const Text(
            "Tài khoản thanh toán",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Wrap(
            runSpacing: 8,
            children: [
              for (CustAcc custAcc in widget.cust.custAcc!
                  .where((element) => element.type == "1")
                  .toList())
                checkBoxItem(custAcc)
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
            "Dịch vụ và mã duyệt lệnh",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          for (var chuyenTien in widget.listChuyenTien)
            renderRowContent(
                title: SERVICE.getNameProduct(chuyenTien.product, context),
                custCodeList: widget.cust.custProduct!
                        .firstWhere(
                            (element) => element.product == chuyenTien.product)
                        .custCode ??
                    "---"),
          for (var thanhToan in widget.listThanhToan)
            renderRowContent(
                title: thanhToan.product,
                custCodeList: widget.cust.custProduct!
                        .firstWhere(
                            (element) => element.product == thanhToan.product)
                        .custCode ??
                    "---")
        ],
      ),
    );
  }

  renderRowContent(
      {required String title,
      required String custCodeList,
      isFontWeight = false}) {
    List<String> list = custCodeList.split(",");
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
            for (String item in list) Text(item),
          ],
        )
      ],
    );
  }

  Widget checkBoxItem(CustAcc custAcc) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 18,
          color: colorGreen_56AB01.withOpacity(0.4),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(custAcc.acc ?? "---"),
        ),
      ],
    );
  }

  Widget renderButton() {
    return Column(
      children: [
        ButtonWidget(
            backgroundColor: secondaryColor,
            onPressed: () async {
              String codeGenOTP = await getQuanLyMaTruyCapCode(
                  widget.cust.id.toString(), context);
              if (mounted) {
                OtpFunction().showDialogEnterPinOTP(
                    context: context,
                    transCode: codeGenOTP,
                    callBack: (String otp, String code) async {
                      var requestBody = {
                        'otp': otp,
                        'code': code,
                        'data': {
                          "id": widget.cust.id,
                          "custAcc": widget.cust.custAcc,
                          "custProduct": widget.cust.custProduct,
                        }
                      };
                      await updateQuyenGiaoDichCust(requestBody);
                    });
              }
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
