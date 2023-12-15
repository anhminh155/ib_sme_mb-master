// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/checkbox.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/validate_form.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/change_pass.dart';
import 'package:ib_sme_mb_view/network/services/forgot_pass_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:provider/provider.dart';
import '../../../common/dialogPin_OTP_Confirm.dart';
import '../../../common/dialog_confirm.dart';
import '../../../common/show_toast.dart';
import '../../../config/config.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../network/services/rsa_service.dart';
import '../../../provider/providers.dart';
import '../../../utils/theme.dart';

class QuenMatKhauScreen extends StatefulWidget {
  const QuenMatKhauScreen({super.key});

  @override
  State<QuenMatKhauScreen> createState() => _QuenMatKhauScreenState();
}

class _QuenMatKhauScreenState extends State<QuenMatKhauScreen>
    with BaseComponent {
  String? codeGenOTP;
  late TextEditingController textEdittingTenDangNhap;
  late TextEditingController textEdittingEmail;
  late TextEditingController textEdittingSoDienThoai;
  late TextEditingController textEdittingSoDangKyKinhDoanh;
  late bool selected = false;
  bool successGetCode = false;
  bool successForgot = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textEdittingTenDangNhap = TextEditingController(text: '');
    textEdittingSoDienThoai = TextEditingController(text: '');
    textEdittingEmail = TextEditingController(text: '');
    textEdittingSoDangKyKinhDoanh = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    textEdittingTenDangNhap.dispose();
    textEdittingEmail.dispose();
    textEdittingSoDangKyKinhDoanh.dispose();
    textEdittingSoDienThoai.dispose();
  }

  forgotPass(requestBody, context, smartOTP) async {
    BaseResponse response =
        await ForgotPass().forgotPass(requestBody, smartOTP);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        successForgot = true;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  checkInfoCustSmartOTP(requestBody, context) async {
    BaseResponse response = await ForgotPass().checkInfoCust(requestBody, true);
    if (response.errorCode == FwError.THANHCONG.value) {
      setState(() {
        codeGenOTP = response.data;
        successGetCode = true;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  checkInfoCustSmstOTP(requestBody, context) async {
    BaseResponse response =
        await ForgotPass().checkInfoCust(requestBody, false);
    if (response.errorCode == FwError.THANHCONG.value) {
      var currentLocale = await getLocale();
      var body = {
        "phone": textEdittingSoDienThoai.text,
        "language": currentLocale.languageCode.toUpperCase()
      };
      await genCodeSmsOTP(body);
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  genCodeSmsOTP(requestBody) async {
    BaseResponse response =
        await ChangePassWord().sendSmsOtp(requestBody, false);
    if (response.errorCode == '0') {
      setState(() {
        successGetCode = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSheet();
  }

  buildSheet() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Wrap(
        children: [
          Container(
            height: 3.5,
            width: 30,
            margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: (MediaQuery.of(context).size.width * 0.45)),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: [
                Text(
                  translation(context)!.forgot_passwordKey,
                  style: const TextStyle(
                      color: colorBlack_727374,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    translation(context)!
                        .please_provide_information_to_reset_your_passwordKey,
                    style: const TextStyle(
                        color: colorBlack_727374,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1.0,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Form(
                key: formKey,
                child: Wrap(
                  children: [
                    InputFormWidget(
                      label: translation(context)!.usernameKey,
                      hintText: translation(context)!.enterKey(
                          translation(context)!.usernameKey.toLowerCase()),
                      note: true,
                      readOnly: false,
                      controller: textEdittingTenDangNhap,
                      validator:
                          ValidateForm(context: context).validateUserName,
                    ),
                    InputFormWidget(
                      label: "Email",
                      hintText: translation(context)!.enterKey("Email"),
                      note: true,
                      readOnly: false,
                      controller: textEdittingEmail,
                      validator: ValidateForm(context: context).validateEmail,
                    ),
                    InputFormWidget(
                      label: translation(context)!.phonenumberKey,
                      hintText: translation(context)!.enterKey(
                          translation(context)!.phonenumberKey.toLowerCase()),
                      note: true,
                      readOnly: false,
                      controller: textEdittingSoDienThoai,
                      textInputType: TextInputType.phone,
                      validator: ValidateForm(context: context)
                          .validateNullPhoneNumber,
                    ),
                    InputFormWidget(
                      label:
                          translation(context)!.business_registration_numberKey,
                      hintText: translation(context)!.enterKey(
                          translation(context)!
                              .business_registration_numberKey
                              .toLowerCase()),
                      note: true,
                      readOnly: false,
                      controller: textEdittingSoDangKyKinhDoanh,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return translation(context)!.could_not_be_empty(
                              translation(context)!
                                  .business_registration_numberKey);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                      width: double.infinity,
                    ),
                    CheckBoxWidget(
                      value: selected,
                      content: Text(
                          translation(context)!.accept_terms_of_serviceKey),
                      handleSelected: (bool? value) {
                        setState(() {
                          selected = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                      width: double.infinity,
                    ),
                    Row(
                      children: [
                        ButtonWidget(
                            backgroundColor: secondaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: translation(context)!.backKey,
                            colorText: Colors.white,
                            haveBorder: false,
                            widthButton: width * 0.4),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Consumer<OtpProvider>(
                            builder: (context, otpProvider, child) {
                          return ButtonWidget(
                              backgroundColor: primaryColor,
                              onPressed: selected == false
                                  ? null
                                  : () async {
                                      await checkRegisterOtp(otpProvider);
                                    },
                              text: translation(context)!.continueKey,
                              colorText: Colors.white,
                              haveBorder: false,
                              widthButton: width * 0.4);
                        })
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkRegisterOtp(otpProvider) async {
    var requestBody = {
      "username": textEdittingTenDangNhap.text,
      "email": textEdittingEmail.text,
      "tel": textEdittingSoDienThoai.text,
      "businessCode": textEdittingSoDangKyKinhDoanh.text,
      "capcha": "1",
      "checkbox": selected
    };
    InitUserOTPModel initUser;
    if (otpProvider.inituserlist.isNotEmpty) {
      initUser = otpProvider.inituserlist.firstWhere(
        (element) => element.username == textEdittingTenDangNhap.text,
        orElse: () =>
            InitUserOTPModel(id: 0, key: '', pin: '', tokenID: '', username: ''),
      );
      // ignore: unnecessary_null_comparison
      if (initUser.id != 0) {
        checkInfoCustSmartOTP(requestBody, context);
        _showDialogEnterPin(initUser);
      } else {
        forgotPassSMS(requestBody);
      }
    } else {
      forgotPassSMS(requestBody);
    }
  }

  forgotPassSMS(requestBody) async {
    await checkInfoCustSmstOTP(requestBody, context);
    if (successGetCode) {
      showDialog(
        context: context,
        builder: (BuildContext contextSMS) {
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
            handleClickButton: (String otp) async {
              var requestBody = {
                'otp': otp,
                'phone': textEdittingSoDienThoai.text,
                'data': {
                  "username": textEdittingTenDangNhap.text,
                  "email": textEdittingEmail.text,
                  "tel": textEdittingSoDienThoai.text,
                  "businessCode": textEdittingSoDangKyKinhDoanh.text,
                  "capcha": "1",
                  "checkbox": selected
                }
              };
              await forgotPass(requestBody, context, false);
              if (successForgot) {
                Navigator.pop(contextSMS);
                showDiaLogConfirm(
                    context: context,
                    close: false,
                    horizontal: 16.0,
                    titleButton: "Đăng nhập",
                    content: const Text(
                      'Thiết lập lại mật khẩu thành công. Mật khẩu mới đã được gửi về số điện thoại đăng kí dịch vụ CBB của Quý khách. Vui lòng đổi mật khẩu trong vòng 24h kể từ khi nhận được mật khẩu mới',
                      style: TextStyle(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    handleContinute: () {
                      Navigator.pop(context);
                    });
              }
            },
          );
        },
      );
    }
  }

  //tài khoản đã kích hoạt Smart OTP nhưng quên mật khẩu trên thiết bị khác (auto SMS OTP)
  //chưa kích hoạt Smart OTP(auto SMS OTP)

  _showDialogEnterPin(initUser) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext contextPin) {
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
              if (codeGenOTP != null) {
                if (Rsa().sha256Convert(pass).compareTo(initUser.pin) == 0) {
                  _showDialogConfirmOTP(initUser, contextPin);
                } else {
                  showToast(
                      context: context,
                      msg: 'Mã PIN không chính xác',
                      color: Colors.red,
                      icon: const Icon(Icons.error));
                }
              }
            },
          );
        });
  }

  _showDialogConfirmOTP(initUser, contextPin) {
    Navigator.pop(contextPin);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext contextOTP) {
          var otp = _createOtp(initUser, codeGenOTP!);
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              handleClickButton: (String pass) async {
                // Navigator.of(context).pop();
                if (successGetCode) {
                  var requestBody = {
                    'code': codeGenOTP,
                    'otp': otp,
                    'data': {
                      "username": textEdittingTenDangNhap.text,
                      "email": textEdittingEmail.text,
                      "tel": textEdittingSoDienThoai.text,
                      "businessCode": textEdittingSoDangKyKinhDoanh.text,
                      "capcha": "1",
                      "checkbox": selected
                    }
                  };
                  await forgotPass(requestBody, context, true);
                  if (successForgot) {
                    Navigator.pop(contextOTP);
                    showDiaLogConfirm(
                        context: context,
                        close: false,
                        horizontal: 16.0,
                        titleButton: "Đăng nhập",
                        content: const Text(
                          'Thiết lập lại mật khẩu thành công. Mật khẩu mới đã được gửi về số điện thoại đăng kí dịch vụ CBB của Quý khách. Vui lòng đổi mật khẩu trong vòng 24h kể từ khi nhận được mật khẩu mới',
                          style: TextStyle(height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        handleContinute: () {
                          Navigator.pop(context);
                        });
                  }
                }
              });
        });
  }

  _createOtp(InitUserOTPModel initUser, String codeGenOTP) {
    var key = initUser.key;
    var password = initUser.pin;
    return Rsa().createOtp(ocraSuiteHighValue, key, codeGenOTP, password);
  }
}
