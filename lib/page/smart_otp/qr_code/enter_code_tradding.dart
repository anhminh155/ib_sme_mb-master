import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/page/smart_otp/qr_code/changed_access_code.dart';
import 'package:provider/provider.dart';

import '../../../common/button.dart';
import '../../../common/form_input_and_label/text_field.dart';
import '../../../common/show_dialog_otp.dart';
import '../../../provider/otp_provider.dart';
import '../../../utils/theme.dart';
import 'enter_pin_screen.dart';

// ignore: must_be_immutable
class EnterCodeTrans extends StatefulWidget {
  final List<InitUserOTPModel> userList;
  final InitUserOTPModel initUser;
  late String? value;
  EnterCodeTrans(
      {super.key, this.value, required this.initUser, required this.userList});

  @override
  State<EnterCodeTrans> createState() => _EnterCodeTransState();
}

class _EnterCodeTransState extends State<EnterCodeTrans> {
  final textControllerCode = TextEditingController();
  final validateAccessTradding = GlobalKey<FormState>();
  String accessCode = '';
  String username = '';
  @override
  void initState() {
    super.initState();
    username = widget.initUser.username;
    accessCode = widget.value!;
  }

  @override
  void dispose() {
    super.dispose();
    textControllerCode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showBottomSheetCode();
  }

  showBottomSheetCode() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Wrap(
        children: [
          Container(
            height: 3.5,
            width: 30,
            margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: (MediaQuery.of(context).size.width * 0.45)),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: const Text(
              "Nhập mã giao dịch",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: 235,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: const Text(
                      "Chọn tài khoản để xác thực giao dịch",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        isDismissible: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: ChangedAccessCode(
                                value: username,
                                handelSellected: (String selectValue) {
                                  setState(() {
                                    username = selectValue;
                                    accessCode = selectValue;
                                  });
                                }),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(accessCode),
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Icon(
                            Icons.expand_circle_down_outlined,
                            color: secondaryColor,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Column(
                      children: [
                        Text(
                          "Qúy khách vui lòng nhập mã giao dịch",
                          style: TextStyle(height: 1.6),
                          textAlign: TextAlign.center,
                        ),
                        Text(" trên kênh Internet Banking")
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: validateAccessTradding,
              child: TextFieldWidget(
                controller: textControllerCode,
                validator: (value) {
                  if (value.toString().isEmpty || value == null) {
                    return "Mã giao dịch không được để trống!";
                  }
                  return null;
                },
                hintText: "Mã giao dịch",
                readOnly: false,
              ),
            ),
          ),
          renderBtnGetOTP()
        ],
      ),
    );
  }

  Container renderBtnGetOTP() {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: ButtonWidget(
            colorText: colorWhite,
            text: "Lấy mã OTP",
            haveBorder: false,
            backgroundColor: secondaryColor,
            widthButton: double.infinity,
            onPressed: () {
              if (validateAccessTradding.currentState!.validate()) {
                final otpProvider = Provider.of<OtpProvider>(context, listen: false);
                final otpSettingModel = sharedpf.getParamSettingOTP();
                if (otpProvider.canRequestOtp(otpSettingModel.betweenOtp)) {
                  String errorMassage = OtpService.validParamsOTP(accessCode);
                  if(errorMassage.isNotEmpty){
                    showDiaLogConfirm(
                      context: context,
                      content: Text(errorMassage,textAlign: TextAlign.center,));
                  }else{
                    showModalBottomSheet<void>(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    isDismissible: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return EnterPinScreen(
                        tranCode: textControllerCode.text,
                        initUser: widget.userList.firstWhere(
                            (element) => element.username == username),
                      );
                    },
                  );
                  }
                } else {
                  OtpFunction().showPopUpTimeRemainOtp(
                    context: context,
                    handleContinute: () {},
                  );
                }
              }
            },
          ),
        );
  }
}
