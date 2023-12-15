// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/dialogPin_OTP_Confirm.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/config/config.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/network/services/rsa_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:ib_sme_mb_view/utils/getDeviceInfo.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../common/button.dart';
import '../../../../common/card_layout.dart';
import '../../../../common/dialog_confirm.dart';
import '../../../../utils/theme.dart';
import 'dart:math';

// ignore: must_be_immutable
class NhapMaXacThucScreen extends StatefulWidget {
  final String initializationCode;
  const NhapMaXacThucScreen({super.key, required this.initializationCode});

  @override
  State<NhapMaXacThucScreen> createState() => _NhapMaXacThucScreenState();
}

class _NhapMaXacThucScreenState extends State<NhapMaXacThucScreen> {
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
          title: const Text("Cài đặt Smart OTP"),
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ButtonWidget(
              backgroundColor: primaryColor,
              onPressed: () {
                if (formKeyPass.currentState!.validate()) {
                  showDiaLogPass();
                }
              },
              text: translation(context)!.continueKey,
              colorText: Colors.white,
              haveBorder: false,
              widthButton: MediaQuery.of(context).size.width),
        ),
      ],
    );
  }

  _enroll(curentPass) async {
    try {
      setState(() {
        _isLoading = true;
      });
      BaseResponse getKeyResponse = await OtpService().getKey(masterKeyId);
      if (getKeyResponse.errorCode == FwError.THANHCONG.value) {
        var slaveKey = getKeyResponse.data;
        bool verify = Rsa().verifySignature(
            slaveKey['publicKey'], slaveKey['signature'], masterKeyPublicKey);
        if (verify) {
          final Random random = Random.secure();
          var key = List<int>.generate(32, (i) => random.nextInt(256));
          var iv = List<int>.generate(16, (i) => random.nextInt(256));

          var aesIvEncrypted =
              Rsa().encrypt64Frombyte(iv, slaveKey['publicKey']);
          var aesKeyEncrypted =
              Rsa().encrypt64Frombyte(key, slaveKey['publicKey']);

          var deviceInfo = await DeviceUtils.getDeviceInfo();
          var pin = Rsa().sha256Convert(curentPass);
          var smsOtpCode = otpController.text;
          OtpModel model = OtpModel(
              aesIvEncrypted: aesIvEncrypted,
              aesKeyEncrypted: aesKeyEncrypted,
              deviceInfo: deviceInfo,
              initializationCode: widget.initializationCode,
              pin: pin,
              rsaKeyId: slaveKey['id'],
              smsOtpCode: smsOtpCode);
          BaseResponse enrollResponse = await OtpService().enroll(model);
          if (enrollResponse.errorCode == FwError.THANHCONG.value) {
            final currentUser =
                LoginResponse.fromJson(localStorage.getItem('currentUser'));
            String keyI = Rsa().aesDecrypt(enrollResponse.data['key'],
                base64Encode(key), base64Encode(iv));
            int id = currentUser.id!;
            String username = currentUser.username!;
            String tokenID = enrollResponse.data['id'];
            //save data
            InitUserOTPModel initUserOTPModel = InitUserOTPModel(
                id: id,
                username: username,
                key: keyI,
                pin: pin,
                tokenID: tokenID);
            await Provider.of<OtpProvider>(context, listen: false)
                .save(initUserOTPModel);
            await Provider.of<OtpProvider>(context, listen: false).load();
            _showSeccessDialog();
          } else {
            showToast(
                context: context,
                msg: enrollResponse.errorMessage!,
                color: Colors.green,
                icon: const Icon(Icons.check));
          }
        }
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> showDiaLogPass() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogPinOtpConfirm(
          title: const Center(
              child: Text(
            "Nhập mã mở khóa",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )),
          length: 6,
          handleClickButton: (String pass) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogPinOtpConfirm(
                  title: const Center(
                    child: Text(
                      "Nhập lại mã mở khóa",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  length: 6,
                  handleClickButton: (String curentPass) async {
                    if (pass.compareTo(curentPass) == 0) {
                      Navigator.pop(context);
                      _enroll(curentPass);
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  _showSeccessDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogPinOtpConfirm(
          title: const Text(
            "Qúy khách đã đăng ký thành công Smart OTP trên thiết bị này!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: 'Để đảm bảo an toàn của Quý khách, ',
              style: TextStyle(
                  color: colorBlack_727374, fontSize: 16, height: 1.5),
              children: <TextSpan>[
                TextSpan(
                    text: 'TUYỆT ĐỐI KHÔNG  ',
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        'tiết lộ thông tin: Tên truy cập/Mật khẩu/Mã mở khóa Smart OTP/Mã kích hoạt Smart OTP vào các website hoặc ứng dụng không phải CBWay'),
              ],
            ),
          ),
          handleClickButton: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      },
    );
  }
}
