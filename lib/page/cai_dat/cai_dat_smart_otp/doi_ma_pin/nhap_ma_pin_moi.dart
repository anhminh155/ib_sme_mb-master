import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/rsa_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_smart_otp/doi_ma_pin/nhap_lai_ma_pin.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:pinput/pinput.dart';

class NhapMaPinMoiScreen extends StatefulWidget {
  final String oldPin;
  final InitUserOTPModel user;
  const NhapMaPinMoiScreen(
      {super.key, required this.oldPin, required this.user});

  @override
  State<NhapMaPinMoiScreen> createState() => _NhapMaPinMoiScreenState();
}

class _NhapMaPinMoiScreenState extends State<NhapMaPinMoiScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _onValidate = false;

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
                          if (_onValidate) {
                            if (Rsa()
                                    .sha256Convert(value!)
                                    .compareTo(widget.user.pin) ==
                                0) {
                              return "Không sử dụng lại mã PIN cũ";
                            }
                          }
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_sharp,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Không sử dụng lại mã PIN gần nhất',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black54),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.1),
              child: ButtonWidget(
                backgroundColor: primaryColor,
                onPressed:
                    pinController.length.compareTo(6) != 0 ? null : _onPressBtn,
                text: translation(context)!.continueKey,
                colorText: Colors.white,
                haveBorder: false,
                widthButton: MediaQuery.of(context).size.width * 0.7,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onPressBtn() {
    setState(() {
      _onValidate = true;
    });
    if (formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NhapLaiMaPinMoiScreen(
                    pin: pinController.text,
                    oldPin: widget.oldPin,
                    user: widget.user,
                  ))).whenComplete(() => pinController.text = '');
    } else {
      setState(() {
        pinController.text = '';
      });
    }
  }
}
