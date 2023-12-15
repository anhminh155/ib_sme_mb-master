// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/checkbox.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/dieu_khoan_dich_vu.dart';
import 'package:ib_sme_mb_view/provider/otp_provider.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';
import '../../../../main.dart';
import 'enter_sms_otp.dart';

// ignore: must_be_immutable
class RestorePin extends StatefulWidget {
  const RestorePin({super.key});

  @override
  State<RestorePin> createState() => _RestorePinState();
}

class _RestorePinState extends State<RestorePin> {
  final passwordController = TextEditingController();
  late bool obscureText = true;
  late bool selected = false;
  final formKeyPass = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
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
                      Form(
                        key: formKeyPass,
                        child: InputFormWidget(
                          validator: (value) {
                            if (value == null || value.toString().isEmpty) {
                              return "Mật khẩu không được bỏ trống!";
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: obscureText,
                          label: "Nhập mật khẩu đăng nhập",
                          note: false,
                          hintText: "Mật khẩu",
                          readOnly: false,
                          suffixIcon: InkWell(
                            onTap: () {
                              onChange();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 14),
                              child: obscureText == true
                                  ? Icon(
                                      Icons.visibility_outlined,
                                      color: colorBlack_727374.withOpacity(0.5),
                                    )
                                  : Icon(Icons.visibility_off,
                                      color:
                                          colorBlack_727374.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text(
                        "Lưu ý:",
                        style: TextStyle(color: secondaryColor),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Mật khẩu đăng nhập là mật khẩu đăng nhập vào tài khoản MB/IB SME của quý khách hàng.",
                        style: TextStyle(height: 1.5),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      CheckBoxWidget(
                        value: selected,
                        handleSelected: (bool? value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                        content: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                'Tôi đã đọc, hiểu rõ, đồng ý và cam kết tuân thủ các ',
                            style: const TextStyle(
                                color: colorBlack_20262C,
                                fontSize: 14,
                                height: 1.5,
                                fontStyle: FontStyle.italic),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'điều khoản và điều kiện ',
                                  style: const TextStyle(color: primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DieuKhoanDichVuScreen(
                                                    id: 32,
                                                  )));
                                    }),
                              const TextSpan(
                                text:
                                    ' sử dụng và thông tin hướng dẫn, quy định, lưu ý sử dụng phương thức xác thực dành cho khách hàng của CB Bank',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                // const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Consumer<OtpProvider>(builder: (context, otpProvider, child) {
            final currentUser =
                LoginResponse.fromJson(localStorage.getItem('currentUser'));
            var user = otpProvider.inituserlist
                .firstWhere((element) => element.id == currentUser.id);
            return ButtonWidget(
                backgroundColor: primaryColor,
                onPressed: selected == false
                    ? null
                    : () async {
                        if (formKeyPass.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          BaseResponse baseResponse =
                              await checkPassword(passwordController.text);
                          setState(() => _isLoading = false);
                          if (!baseResponse.data) {
                            showToast(
                                context: context,
                                msg: "Mật khẩu không chính xác!",
                                color: Colors.red,
                                icon: const Icon(Icons.error));
                          } else {
                            _sendSmsOtp(context, user);
                          }
                        }
                      },
                text: translation(context)!.continueKey,
                colorText: Colors.white,
                haveBorder: false,
                widthButton: MediaQuery.of(context).size.width);
          }),
        )
      ],
    );
  }

  Future<BaseResponse> checkPassword(String password) async {
    return await OtpService().checkPassword(password);
  }

  Future<void> _sendSmsOtp(BuildContext context, InitUserOTPModel user) async {
    setState(() {
      _isLoading = true;
    });
    BaseResponse sendSmsOtpResponse =
        await OtpService().sendSmsOtp(otpTokenId: user.tokenID);
    setState(() {
      _isLoading = false;
    });
    if (sendSmsOtpResponse.errorCode == FwError.THANHCONG.value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EnterSmsOtpScreen()));
    } else {
      showToast(
          context: context,
          msg: sendSmsOtpResponse.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }
}
