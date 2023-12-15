import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/network/services/cus_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_ma_truy_cap/ma_truy_cap_ket_qua.dart';
import 'package:intl/intl.dart';

import '../../../common/button.dart';
import '../../../common/card_layout.dart';
import '../../../common/show_dialog_otp.dart';
import '../../../common/show_toast.dart';
import '../../../enum/enum.dart';
import '../../../model/model.dart';
import '../../../network/services/get_code_gen_otp_service.dart';
import '../../../utils/theme.dart';

class MaTruyCapXacThucWidget extends StatefulWidget {
  final Cust cust;
  final String type;
  const MaTruyCapXacThucWidget(
      {super.key, required this.cust, required this.type});

  @override
  State<MaTruyCapXacThucWidget> createState() => _MaTruyCapXacThucWidgetState();
}

class _MaTruyCapXacThucWidgetState extends State<MaTruyCapXacThucWidget> {
  onCreateCust(requestBody) async {
    BaseResponse response = await CusService().create(requestBody);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      return Cust.fromJson(response.data);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  onUpdateCust(requestBody) async {
    BaseResponse response = await CusService().update(requestBody);
    if (response.errorCode == FwError.THANHCONG.value && mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      return Cust.fromJson(response.data);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  getQuanLyMaTruyCapCode(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.QUANLYMATRUYCAP, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
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
                formXacThucCust(widget.cust),
                const SizedBox(
                  height: 24,
                ),
                ButtonWidget(
                    backgroundColor: secondaryColor,
                    onPressed: () async {
                      final currentUser = LoginResponse.fromJson(
                          localStorage.getItem('currentUser'));
                      Cust custNew = Cust();
                      String codeGenOTP = await getQuanLyMaTruyCapCode(
                          widget.type == "edit"
                              ? widget.cust.id.toString()
                              : currentUser.id,
                          context);
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
                              if (widget.type == "create") {
                                custNew = await onCreateCust(requestBody);
                              } else {
                                custNew = await onUpdateCust(requestBody);
                              }
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MaTruyCapKetQuaWidget(
                                      cust: custNew,
                                      type: widget.type,
                                      codeOTP: codeGenOTP,
                                    ),
                                  ),
                                );
                              }
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
                    widthButton: double.infinity)
              ],
            ),
          ),
        ));
  }

  Widget formXacThucCust(Cust cust) {
    return CardLayoutWidget(
      child: Wrap(
        runSpacing: 16,
        children: [
          rowSpaceBW('Họ và tên', cust.fullname!),
          rowSpaceBW('Loại giấy tờ', cust.indentitypapers!),
          rowSpaceBW('Số giấy tờ', cust.idno!),
          rowSpaceBW('Ngày sinh',
              DateFormat('dd/MM/yyyy').format(DateTime.parse(cust.birthday!))),
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
}
