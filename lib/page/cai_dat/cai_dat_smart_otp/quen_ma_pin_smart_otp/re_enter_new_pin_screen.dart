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
import 'package:ib_sme_mb_view/network/services/rsa_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../provider/otp_provider.dart';

class ReEnterNewPinScreens extends StatefulWidget {
  final String pin;
  final InitUserOTPModel inituser;
  const ReEnterNewPinScreens(
      {super.key, required this.pin, required this.inituser});

  @override
  State<ReEnterNewPinScreens> createState() => _ReEnterNewPinScreensState();
}

class _ReEnterNewPinScreensState extends State<ReEnterNewPinScreens> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  late InitUserOTPModel initUser;
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
                      if (widget.pin != value) {
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
              child: Builder(builder: (context) {
                return ButtonWidget(
                  backgroundColor: primaryColor,
                  onPressed: pinController.length.compareTo(6) != 0
                      ? null
                      : () {
                          _onPressRestorePin();
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

  Future<void> _onPressRestorePin() async {
    setState(() => _isLoading = true);
    String pin = Rsa().sha256Convert(pinController.text);
    OtpRestorePinRequest request = OtpRestorePinRequest(
        otpTokenId: widget.inituser.tokenID, pin: pin, smsOtpCode: '111111');
    BaseResponse response = await OtpService().restorePin(request);
    setState(() => _isLoading = false);
    if (response.errorCode == FwError.THANHCONG.value) {
      InitUserOTPModel newUser = InitUserOTPModel(
          id: widget.inituser.id,
          tokenID: widget.inituser.tokenID,
          username: widget.inituser.username,
          key: widget.inituser.key,
          pin: pin);
      await Provider.of<OtpProvider>(context, listen: false).save(newUser);
      _showDiaLogNote();
    } else if (mounted) {
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
        handleContinute: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
  }
}
