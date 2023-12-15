import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_smart_otp/quen_ma_pin_smart_otp/re_enter_new_pin_screen.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:pinput/pinput.dart';

class EnterNewPinScreen extends StatefulWidget {
  final String smsOtpCode;
  final InitUserOTPModel inituser;
  const EnterNewPinScreen(
      {super.key, required this.smsOtpCode, required this.inituser});

  @override
  State<EnterNewPinScreen> createState() => _EnterNewPinScreensState();
}

class _EnterNewPinScreensState extends State<EnterNewPinScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 55,
          title: const Text("Đổi mã pin Smart OTP"),
          centerTitle: true,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
        ),
        body: renderBodyDoiPinSmatOTP());
  }

  renderBodyDoiPinSmatOTP() {
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'NHẬP MÃ PIN MỚI',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.1),
              child: Column(
                children: [
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
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                ],
              ),
            ),
            renderNextBtn()
          ],
        ),
      ),
    );
  }

  renderNextBtn() {
    return ButtonWidget(
      backgroundColor: primaryColor,
      onPressed: pinController.length.compareTo(6) != 0
          ? null
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReEnterNewPinScreens(
                            pin: pinController.text,
                            inituser: widget.inituser,
                          ))).whenComplete(() => pinController.text = '');
            },
      text: translation(context)!.continueKey,
      colorText: Colors.white,
      haveBorder: false,
      widthButton: MediaQuery.of(context).size.width * 0.7,
    );
  }
}
