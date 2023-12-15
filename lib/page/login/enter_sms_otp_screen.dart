// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/change_pass.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/login/change_password_screen.dart';
import 'package:pinput/pinput.dart';

import '../../../common/button.dart';
import '../../../utils/theme.dart';

class EnterSMSOTPScreen extends StatefulWidget {
  final bool isFirstLogin;
  final String phoneNumber;
  const EnterSMSOTPScreen({super.key, required this.isFirstLogin, required this.phoneNumber});

  @override
  State<EnterSMSOTPScreen> createState() => _EnterSMSOTPScreenState();
}

class _EnterSMSOTPScreenState extends State<EnterSMSOTPScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isSendSMSOTP = false;
  bool _isLoading = false;
  final defaultPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
    ),
  );
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Timer? timer;
  int _start = 60;

  void startTimer() async {
    timer?.cancel();
    setState(() {
      _isLoading = true;
    });
    try {
      isSendSMSOTP = await _sendSmsOtp();
    } catch (_) {}
    setState(() {
      _isLoading = false;
    });
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.of(context).pop(false);
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
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác thực OTP"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Stack(
        children: [renderBody(), if (_isLoading) const LoadingCircle()],
      ),
    );
  }

  renderBody() {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                "Quý khách vui lòng nhập mã xác thực đã được gửi về số điện thoại ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: colorBlack_727374),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                widget.phoneNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: primaryColor),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'SMS OTP sẽ hết hạn sau :',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                      text: ' ${_start}s',
                      style: const TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            renderPinInput(),
            const SizedBox(
              height: 30,
            ),
            renderResend(),
            const SizedBox(
              height: 30,
            ),
            renderButtons(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  renderResend() {
    return Container(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
                text: 'Nhấn ', style: TextStyle(color: Colors.black)),
            TextSpan(
              text: 'Gửi lại ',
              style: const TextStyle(color: secondaryColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapResend,
            ),
            const TextSpan(
              text: 'Nếu không nhận được mã xác thực sau ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: ' ${_start}s',
              style: const TextStyle(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  _onTapResend() {
    setState(() {
      _start = 60; // Thiết lập lại thời gian ban đầu
    });
    startTimer();
  }

  Future<bool> _sendSmsOtp() async {
    var request = {"language": "VN"};
    BaseResponse response = await ChangePassWord().sendSmsOtp(request);
    if (response.errorCode == FwError.THANHCONG.value) {
      return true;
    }
    return false;
  }

  renderButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: ButtonWidget(
            colorText: colorWhite,
            text: translation(context)!.backKey,
            haveBorder: false,
            backgroundColor: primaryColor,
            widthButton: double.infinity,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: ButtonWidget(
            colorText: colorWhite,
            text: translation(context)!.continueKey,
            haveBorder: false,
            backgroundColor: secondaryColor,
            widthButton: double.infinity,
            onPressed: pinController.length == 6 ? _checkSMSOTP : null,
          ),
        ),
      ],
    );
  }

  renderPinInput() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Form(
        key: formKey,
        child: Pinput(
          autofocus: true,
          length: 6,
          keyboardType: TextInputType.number,
          controller: pinController,
          focusNode: focusNode,
          obscureText: false,
          defaultPinTheme: defaultPinTheme,
          validator: (value) {
            return null;
          },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (pin) {
            focusNode.unfocus();
            if (formKey.currentState!.validate()) {
              // do something
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
                color: const Color.fromRGBO(23, 171, 144, 1),
              ),
            ],
          ),
          submittedPinTheme: defaultPinTheme.copyBorderWith(
            border: const Border(bottom: BorderSide.none),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: const Border(bottom: BorderSide(color: Colors.redAccent)),
          ),
        ),
      ),
    );
  }

  _checkSMSOTP() async {
    var request = {"otp": pinController.text};
    setState(() {
      _isLoading = true;
    });
    BaseResponse response = await ChangePassWord().verifySmsOtp(request);
    setState(() {
      _isLoading = false;
    });
    if (response.errorCode == "0") {
      if (!widget.isFirstLogin) {
        Navigator.of(context).pop(true);
      } else {
        timer!.cancel();
        bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangeFirstPassword(),
            ));
        Navigator.of(context).pop(result);
      }
    } else {
      showDiaLogConfirm(
          context: context, content: const Text('Mã SMS OTP không chính xác'));
    }
  }
}
