import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/provider/otp_provider.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../model/model.dart';
import '../../../../network/services/rsa_service.dart';
import '../../../../provider/custInfo_provider.dart';
import 'nhap_ma_pin_moi.dart';

class DoiPinSmartOTPScreen extends StatefulWidget {
  const DoiPinSmartOTPScreen({super.key});

  @override
  State<DoiPinSmartOTPScreen> createState() => _DoiPinSmartOTPScreenState();
}

class _DoiPinSmartOTPScreenState extends State<DoiPinSmartOTPScreen> {
  final pinController = TextEditingController();
  final errorTextController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isErrorText = false;
  late Cust cust;

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
    cust = Provider.of<CustInfoProvider>(context, listen: false).cust!;
  }

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
        child: Consumer<OtpProvider>(builder: (context, otpProvider, child) {
          var user = otpProvider.inituser;
          return Column(
            children: [
              const Text(
                'NHẬP MÃ MỞ KHÓA CŨ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.1),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Form(
                    key: formKey,
                    child: Pinput(
                      autofocus: true,
                      length: 6,
                      keyboardType: TextInputType.number,
                      controller: pinController,
                      focusNode: focusNode,
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      showCursor: true,
                      errorText: errorTextController.text,
                      forceErrorState: _isErrorText,
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
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.1),
                child: ButtonWidget(
                  backgroundColor: primaryColor,
                  onPressed: pinController.length.compareTo(6) != 0
                      ? null
                      : () => _onPressBtn(user),
                  text: translation(context)!.continueKey,
                  colorText: Colors.white,
                  haveBorder: false,
                  widthButton: MediaQuery.of(context).size.width * 0.7,
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  _onPressBtn(user) {
    if (user.pin == Rsa().sha256Convert(pinController.text)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NhapMaPinMoiScreen(
                    oldPin: pinController.text,
                    user: user,
                  ))).whenComplete(() => pinController.text = '');
    } else {
      setState(() {
        pinController.text = '';
        _isErrorText = true;
        errorTextController.text = 'Mã pin không chính xác';
      });
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }
}
