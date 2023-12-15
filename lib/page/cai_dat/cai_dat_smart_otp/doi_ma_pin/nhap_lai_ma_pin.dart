// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../network/services/rsa_service.dart';

class NhapLaiMaPinMoiScreen extends StatefulWidget {
  final String oldPin;
  final String pin;
  final InitUserOTPModel user;
  const NhapLaiMaPinMoiScreen(
      {super.key, required this.pin, required this.oldPin, required this.user});

  @override
  State<NhapLaiMaPinMoiScreen> createState() => _NhapLaiMaPinMoiScreenState();
}

class _NhapLaiMaPinMoiScreenState extends State<NhapLaiMaPinMoiScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
        body: Stack(
          children: [
            renderBodyDoiPinSmatOTP(),
            if (_isLoading) const LoadingCircle()
          ],
        ));
  }

  renderBodyDoiPinSmatOTP() {
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'NHẬP LẠI MÃ PIN',
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
                    validator: (value) {
                      if (widget.pin != value!) {
                        return 'Mã pin không giống nhau';
                      }
                      return null;
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      focusNode.unfocus();
                      formKey.currentState!.validate();
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
              child:
                  Consumer<OtpProvider>(builder: (context, otpProvider, child) {
                // var user = otpProvider.items.firstWhere((element) =>
                //     element.id ==
                //     Provider.of<SecurityModel>(context, listen: false)
                //         .currentUser!
                //         .id);
                return ButtonWidget(
                  backgroundColor: primaryColor,
                  onPressed: pinController.length.compareTo(6) != 0
                      ? null
                      : () {
                          _onPressChangePin(widget.oldPin, widget.pin);
                        },
                  text: translation(context)!.continueKey,
                  colorText: Colors.white,
                  haveBorder: false,
                  widthButton: MediaQuery.of(context).size.width * 0.7,
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onPressChangePin(oldPin, newPin) async {
    setState(() => _isLoading = true);
    var ioldPin = Rsa().sha256Convert(oldPin);
    var inewPin = Rsa().sha256Convert(newPin);
    OtpChangePinRequest request = OtpChangePinRequest(
        otpTokenId: widget.user.tokenID, oldPin: ioldPin, pin: inewPin);
    BaseResponse response = await OtpService().changePin(request);
    setState(() => _isLoading = false);
    if (response.errorCode == FwError.THANHCONG.value) {
      InitUserOTPModel newUser = InitUserOTPModel(
          id: widget.user.id,
          tokenID: widget.user.tokenID,
          username: widget.user.username,
          key: widget.user.key,
          pin: inewPin);
      await Provider.of<OtpProvider>(context, listen: false).save(newUser);
      _showDiaLogNote();
    } else {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  _showDiaLogNote() {
    return showDiaLogConfirm(
        context: context,
        content: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Quý khách đã đổi mà PIN thành công trên thiết bị này!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Để đảm bảo an toàn tài khoản của Quý khách, ',
                  style: TextStyle(color: Colors.black87, height: 1.6),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'TUYỆT ĐỐI KHÔNG ',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600)),
                    TextSpan(
                      text:
                          'tiết lộ cho bất kỳ ai hoặc nhập thông tin: Tên truy cập/Mật khẩu/Mã PIN vào các website hoặc ứng dụng không phải của CB',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        titleButton: 'Về trang chủ',
        close: false,
        handleContinute: () =>
            Navigator.popUntil(context, (route) => route.isFirst));
  }
}
