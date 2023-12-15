// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/checkbox.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/show_important_noti.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/network/services/otp_service.dart';
import 'package:ib_sme_mb_view/page/cai_dat/cai_dat_smart_otp/cai_dat_smart_otp/nhap_ma_xac_thuc.dart';
import 'package:ib_sme_mb_view/page/tien_ich/ho_tro/dieu_khoan_dich_vu.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

// ignore: must_be_immutable
class NhapMatKhauXacThucScreen extends StatefulWidget {
  const NhapMatKhauXacThucScreen({
    super.key,
  });

  @override
  State<NhapMatKhauXacThucScreen> createState() =>
      _NhapMatKhauXacThucScreenState();
}

class _NhapMatKhauXacThucScreenState extends State<NhapMatKhauXacThucScreen> {
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
          child: ButtonWidget(
              backgroundColor: primaryColor,
              onPressed: selected == false ? null : _onPressBtn,
              text: translation(context)!.continueKey,
              colorText: Colors.white,
              haveBorder: false,
              widthButton: MediaQuery.of(context).size.width),
        )
      ],
    );
  }

  Future<void> _onPressBtn() async {
    if (formKeyPass.currentState!.validate()) {
      try {
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
          initialization(context);
        }
      } catch (e) {
        showDiaLogConfirm(content: Text(e.toString()), context: context);
      }
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<BaseResponse> checkPassword(String password) async {
    return await OtpService().checkPassword(password);
  }

  Future<void> initialization(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      BaseResponse initializationResponse = await OtpService().initialization();
      if (initializationResponse.errorCode == FwError.THANHCONG.value) {
        BaseResponse sendSmsOtpResponse = await OtpService()
            .sendSmsOtp(initializationCode: initializationResponse.data);
        if (sendSmsOtpResponse.errorCode == FwError.THANHCONG.value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NhapMaXacThucScreen(
                        initializationCode: initializationResponse.data,
                      )));
        } else {
          _showLog(
              sendSmsOtpResponse.errorCode, sendSmsOtpResponse.errorMessage);
        }
      } else {
        _showLog(initializationResponse.errorCode,
            initializationResponse.errorMessage);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> disableTokenTID() async {
    setState(() {
      _isLoading = true;
    });
    BaseResponse disableTokenTIDResponse = await OtpService().disableTokenID();
    setState(() {
      _isLoading = false;
    });
    if (disableTokenTIDResponse.data ?? false) {
      initialization(context);
    }
    showToast(
        context: context,
        msg: 'Có lỗi xảy ra!!!',
        color: Colors.red,
        icon: const Icon(Icons.error));
  }

  _showLog(errorCode, errorMessage) {
    if (errorCode == 'OTP_0001') {
      return showImportantNoti(context,
          content:
              'Tài khoản của quý khách đã được kịch hoạt trên thiết bị khác,Quý khách có muốn đang ký lại',
          func: disableTokenTID);
    } else {
      return showDiaLogConfirm(
          context: context,
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ));
    }
  }
}
