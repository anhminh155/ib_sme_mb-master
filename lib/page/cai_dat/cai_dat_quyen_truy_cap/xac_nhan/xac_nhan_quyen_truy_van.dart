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

class XacNhanQuyenTruyVanWidget extends StatefulWidget {
  final Cust cust;
  final AllAccountResponse allAccountResponse;
  const XacNhanQuyenTruyVanWidget(
      {super.key, required this.cust, required this.allAccountResponse});

  @override
  State<XacNhanQuyenTruyVanWidget> createState() =>
      _CapNhatQuyenTruyVanScreenState();
}

class _CapNhatQuyenTruyVanScreenState extends State<XacNhanQuyenTruyVanWidget> {
  getQuanLyMaTruyCapCode(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.QUANLYQUYENTRUYCAP, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    }
  }

  updateQuyenTruyVanCust(requestBody) async {
    BaseResponse response =
        await CusService().updateQuyenTruyVanCust(requestBody);
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
          title: const Text("Xác nhận quyền truy vấn"),
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
                if (widget.allAccountResponse.fd != null &&
                        widget.allAccountResponse.fd!.isNotEmpty ||
                    widget.allAccountResponse.ln != null &&
                        widget.allAccountResponse.ln!.isNotEmpty)
                  taiKhoanTienGuiVay(),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Quyền truy cập"),
              Text(
                "Quyền truy vấn",
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
            "Tài khoản thanh toán cho phép mã truy cập thực hiện truy vấn",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Text(
            "Tài khoản thanh toán",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Wrap(
            runSpacing: 8,
            children: [
              for (CustAcc custAcc in widget.cust.custAcc!
                  .where((element) =>
                      element.type == "2" && element.accType == "1")
                  .toList())
                checkBoxItem(custAcc)
            ],
          ),
        ],
      ),
    );
  }

  Widget taiKhoanTienGuiVay() {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          if (widget.allAccountResponse.fd != null &&
              widget.allAccountResponse.fd!.isNotEmpty)
            const Text(
              "Tài khoản tiền gửi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          Wrap(
            runSpacing: 8,
            children: [
              for (CustAcc custAcc in widget.cust.custAcc!
                  .where((element) =>
                      element.type == "2" && element.accType == "2")
                  .toList())
                checkBoxItem(custAcc),
            ],
          ),
          if (widget.allAccountResponse.ln != null &&
              widget.allAccountResponse.ln!.isNotEmpty)
            const Text(
              "Tài khoản tiền vay",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          Wrap(
            runSpacing: 8,
            children: [
              for (CustAcc custAcc in widget.cust.custAcc!
                  .where((element) =>
                      element.type == "2" && element.accType == "3")
                  .toList())
                checkBoxItem(custAcc)
            ],
          )
        ],
      ),
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
                        'data': widget.cust
                      };
                      await updateQuyenTruyVanCust(requestBody);
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
