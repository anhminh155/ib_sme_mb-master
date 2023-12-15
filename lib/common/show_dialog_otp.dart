import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialogPin_OTP_Confirm.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/config/config.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/network/services/rsa_service.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

import '../provider/providers.dart';

class OtpFunction {
  showDialogEnterPinOTP({required BuildContext context,required String transCode,required Function callBack}) {
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);
    final OtpSettingModel otpSettingModel = sharedpf.getParamSettingOTP();
    final initUser = otpProvider.inituser;
    if (otpProvider.canRequestOtp(otpSettingModel.betweenOtp)) {
      if (initUser != null) {
        String errorMassage = OtpService.validParamsOTP(initUser.username);
        if(errorMassage.isNotEmpty){
          showDiaLogConfirm(
            context: context,
            content: Text(errorMassage,textAlign: TextAlign.center,));
        }else{
          try {
          var otp = _createOtp(initUser, transCode);
          showPopupEnterPin(context, initUser, otp, transCode,otpProvider, callBack);
        } catch (_) {
          showToast(
              context: context,
              msg: 'Có lỗi xảy ra!!!',
              color: Colors.red,
              icon: const Icon(Icons.error));
        }
        }
      } else {
        showDiaLogConfirm(
            context: context,
            content: const Text('Quý khách chưa đăng ký Smart OTP'));
      }
    } else {
      OtpFunction().showPopUpTimeRemainOtp(
        context: context,
        handleContinute: () {},
      );
    }
  }

  Future<dynamic> showPopupEnterPin(BuildContext context, InitUserOTPModel initUser, String otp, String transCode,otpProvider, Function callBack) {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogPinOtpConfirm(
              note: true,
              length: 6,
              title: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Xác thực giao dịch",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Vui lòng nhập',
                      style: TextStyle(
                          color: colorBlack_20262C,
                          fontSize: 12,
                          height: 1.5),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' mật khẩu CB-SmartOTP ',
                          style: TextStyle(color: primaryColor, fontSize: 12),
                        ),
                        TextSpan(
                            text: 'của quý khách để xác nhận giao dịch',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              handleClickButton: (String pass) {
                Navigator.of(context).pop();
                if (Rsa().sha256Convert(pass).compareTo(initUser.pin) == 0) {
                  _showDialogConfirmOTP(
                      context, initUser, otp, transCode, callBack);
                      otpProvider.updateOtpRequestTime();
                      OtpService.resetPin(initUser.username);
                } else {
                  String errorMessage = OtpService.updateEnterFalsePinOTP(initUser.username);
                  showToast(
                      context: context,
                      msg: errorMessage.isNotEmpty?errorMessage:'Mã PIN không chính xác',
                      color: Colors.red,
                      icon: const Icon(Icons.error));
                }
              },
            );
          },
        );
  }


  _showDialogConfirmOTP(BuildContext context, InitUserOTPModel user, String otp,
      String transCode, Function callBack) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogPinOtpConfirm(
          controller: TextEditingController(text: otp),
          note: true,
          obscureText: false,
          length: 8,
          title: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Xác thực giao dịch",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Mã xác thực giao dịch bằng hình thức CB-Smart OTP của quý khách được hiển thị dưới đây. Quý khách vui lòng ấn ${translation(context)!.continueKey} để hoàn tất giao dịch',
                  style: const TextStyle(
                      color: colorBlack_20262C, fontSize: 12, height: 1.5),
                ),
              ),
            ],
          ),
          handleClickButton: (String pass) {
            Navigator.of(context).pop();
            callBack(otp, transCode);
          },
        );
      },
    );
  }

  showDialogEnterSmsOTP(
      {required BuildContext context, required Function callBack}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogPinOtpConfirm(
          note: true,
          length: 6,
          title: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Xác thực giao dịch",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Vui lòng nhập',
                  style: TextStyle(
                      color: colorBlack_20262C, fontSize: 12, height: 1.5),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' CB-SMS OTP ',
                      style: TextStyle(color: primaryColor, fontSize: 12),
                    ),
                    TextSpan(
                        text: 'của quý khách để xác nhận giao dịch',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          handleClickButton: (String pass) {
            Navigator.of(context).pop();
            callBack(pass);
          },
        );
      },
    );
  }

  String _createOtp(InitUserOTPModel initUser, transCode) {
    var key = initUser.key;
    var password = initUser.pin;
    return Rsa().createOtp(ocraSuiteHighValue, key, transCode, password);
  }

  showPopUpTimeRemainOtp(
      {required BuildContext context, required Function handleContinute}) {
    showDiaLogConfirm(
            context: context,
            content: const RemainingWidget(),
            handleContinute: handleContinute)
        .whenComplete(() => handleContinute());
  }
}

class RemainingWidget extends StatefulWidget {
  const RemainingWidget({super.key});

  @override
  State<RemainingWidget> createState() => _RemainingWidgetState();
}

class _RemainingWidgetState extends State<RemainingWidget> {
  Timer? timer;
  int _start = 30;

  void startTimer() {
    _start = Provider.of<OtpProvider>(context, listen: false).remainingSeconds;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.of(context).pop();
          });
        } else if (mounted) {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Vui lòng đợi $_start giây trước khi yêu cầu lại Smart OTP.',
      textAlign: TextAlign.center,
    );
  }
}
