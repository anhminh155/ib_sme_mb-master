// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/network/services/rsa_service.dart';
import 'package:ib_sme_mb_view/page/smart_otp/qr_code/otp_screen.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';

class EnterPinScreen extends StatefulWidget {
  final InitUserOTPModel initUser;
  final String tranCode;
  const EnterPinScreen(
      {super.key, required this.tranCode, required this.initUser});

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    // const fillColor = Color.fromRGBO(243, 246, 249, 0);
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 30,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
    );
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Nhập mã pin smart OTP',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Form(
                key: formKey,
                child: Pinput(
                  autofocus: true,
                  length: 6,
                  keyboardType: TextInputType.number,
                  controller: pinController,
                  focusNode: focusNode,
                  // obscuringCharacter: '*',
                  obscureText: true,
                  // androidSmsAutofillMethod:
                  //     AndroidSmsAutofillMethod.smsUserConsentApi,
                  // listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  validator: (value) {
                    if (Rsa().sha256Convert(value.toString()) != widget.initUser.pin) {
                      return 'Mã pin không đúng';
                    }
                    return null;
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    Navigator.of(context).pop();
                    if (formKey.currentState!.validate()) {
                      focusNode.unfocus();
                      _showBottomOTP(createOtp());
                      OtpService.resetPin(widget.initUser.username);
                      Provider.of<OtpProvider>(context, listen: false).updateOtpRequestTime();
                    }else{
                      String errorMessage = OtpService.updateEnterFalsePinOTP(widget.initUser.username);
                      showToast(
                      context: context,
                      msg: errorMessage.isNotEmpty?errorMessage:'Mã PIN không chính xác',
                      color: Colors.red,
                      icon: const Icon(Icons.error));
                    }
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  // focusedPinTheme: defaultPinTheme.copyWith(
                  //   decoration: defaultPinTheme.decoration!.copyWith(
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: focusedBorderColor),
                  //   ),
                  // ),
                  submittedPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border(bottom: BorderSide.none),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border(bottom: BorderSide(color: Colors.redAccent)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ));
  }

  _showBottomOTP(otp) {
    return showModalBottomSheet<void>(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        builder: (context) {
          return OtpScreen(otp: otp, tranCode: widget.tranCode);
          // ignore: unnecessary_set_literal
        }).whenComplete(() => {Navigator.of(context).pop()});
  }

  createOtp() {
    var key = widget.initUser.key;
    var password = widget.initUser.pin;
    return Rsa().createOtp(ocraSuiteHighValue, key, widget.tranCode, password);
  }

  createOtherOtp() {
    var key = widget.initUser.key;
    var password = widget.initUser.pin;
    return Rsa().createOtp(ocraSuiteHighValue, key, widget.tranCode, password);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
