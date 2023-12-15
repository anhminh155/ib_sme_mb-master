// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_smart_otp/quen_ma_pin_smart_otp/enter_new_pin_screen.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../common/button.dart';
import '../../../../common/card_layout.dart';
import '../../../../common/dialog_confirm.dart';
import '../../../../utils/theme.dart';

// ignore: must_be_immutable
class EnterSmsOtpScreen extends StatefulWidget {
  const EnterSmsOtpScreen({super.key});
  @override
  State<EnterSmsOtpScreen> createState() => _EnterSmsOtpScreenState();
}

class _EnterSmsOtpScreenState extends State<EnterSmsOtpScreen> {
  final otpController = TextEditingController();
  late bool obscureText = true;
  late bool selected = false;
  final formKeyPass = GlobalKey<FormState>();
  bool _isLoading = false;
  final focusNode = FocusNode();

  static const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
  // const fillColor = Color.fromRGBO(243, 246, 249, 0);
  final defaultPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
      fontSize: 30,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
    ),
  );
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
    timer?.cancel();
  }

  onChange() {
    if (obscureText == true) {
      setState(() {
        obscureText = false;
      });
    } else {
      setState(() {
        obscureText = true;
      });
    }
  }

  Timer? timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.of(context).pop();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 55,
          title: const Text("Quên pin Smart OTP"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: Stack(
          children: [
            renderBodyNhapMatKhau(),
            if (_isLoading) const LoadingCircle()
          ],
        ));
  }

  renderBodyNhapMatKhau() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom * 0.75),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                CardLayoutWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Nhập mã xác thực",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Mã xác thực đã được gửi đến số điện thoại ',
                          style: const TextStyle(
                            color: colorBlack_20262C,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: '096xxx1289 ',
                            ),
                            const TextSpan(text: ' và sẽ hết hạn sau'),
                            TextSpan(
                              text: ' ${_start}s',
                              style: const TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Form(
                        key: formKeyPass,
                        child: Pinput(
                          autofocus: true,
                          length: 6,
                          keyboardType: TextInputType.number,
                          controller: otpController,
                          focusNode: focusNode,
                          obscureText: false,
                          defaultPinTheme: defaultPinTheme,
                          showCursor: true,
                          validator: (value) {
                            return null;
                          },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
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
                          submittedPinTheme: defaultPinTheme.copyBorderWith(
                            border: const Border(bottom: BorderSide.none),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: const Border(
                                bottom: BorderSide(color: Colors.redAccent)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Không nhận được mã xác thực? ',
                          style: const TextStyle(
                            color: colorBlack_20262C,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Gửi lại',
                                style: const TextStyle(color: primaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() async {
                                      timer?.cancel();
                                      startTimer();
                                    });
                                  }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'Để đảm bảo an toàn tài khoản của Quý khách, ',
                          style: TextStyle(
                              color: colorBlack_20262C,
                              fontSize: 14,
                              height: 1.5,
                              fontStyle: FontStyle.italic),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'TUYỆT ĐỐI KHÔNG ',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: 'cung cấp mã kích hoạt cho bất cứ ai',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        renderBtn()
      ],
    );
  }

  renderBtn() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Consumer<OtpProvider>(builder: (context, otpProvider, child) {
        var initUser = otpProvider.inituser;
        return ButtonWidget(
            backgroundColor: primaryColor,
            onPressed: () {
              if (formKeyPass.currentState!.validate()) {
                _verifiSmsOtp(initUser!);
              }
            },
            text: translation(context)!.continueKey,
            colorText: Colors.white,
            haveBorder: false,
            widthButton: MediaQuery.of(context).size.width);
      }),
    );
  }

  Future _verifiSmsOtp(InitUserOTPModel initUser) async {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterNewPinScreen(
                smsOtpCode: otpController.text, inituser: initUser),
          ));
      // setState(() => _isLoading = true);
      // BaseResponse response = await OtpService().verifiSmsOtp(
      //     context: context,
      //     otpTokenId: initUser.tokenID,
      //     smsOtpCode: otpController.text);
      // if (response.data != null) {
      //   if (response.data) {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => EnterNewPinScreen(
      //               smsOtpCode: otpController.text, inituser: initUser),
      //         ));
      //   }
      // } else {
      //   showDiaLogConfirm(
      //       content: Text(response.errorMessage.toString()), context: context);
      // }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
