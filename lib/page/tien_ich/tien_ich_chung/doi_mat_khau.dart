import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/show_dialog_otp.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/common/validate_form.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/authen_service.dart';
import 'package:ib_sme_mb_view/network/services/change_pass.dart';
import 'package:ib_sme_mb_view/network/services/get_code_gen_otp_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/page/login/login.dart';
import 'package:ib_sme_mb_view/provider/custInfo_provider.dart';
import 'package:ib_sme_mb_view/provider/otp_provider.dart';
import 'package:ib_sme_mb_view/provider/special_characters_provider.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../utils/theme.dart';

class DoiMatKhauScreen extends StatefulWidget {
  const DoiMatKhauScreen({super.key});

  @override
  State<DoiMatKhauScreen> createState() => _DoiMatKhauScreenState();
}

class _DoiMatKhauScreenState extends State<DoiMatKhauScreen>
    with BaseComponent {
  late TextEditingController oldPass;
  late TextEditingController newPass;
  late TextEditingController curentPass;
  late bool viewOldPass = true;
  late bool viewNewPass = true;
  late bool viewCurentPass = true;
  late bool statusValid = false;
  bool getCodeSMS = false;
  final formKeyPass = GlobalKey<FormState>();
  final formKeyNewPass = GlobalKey<FormState>();
  final formKeyCurentPass = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    oldPass = TextEditingController(text: '');
    newPass = TextEditingController(text: '');
    curentPass = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    oldPass.dispose();
    newPass.dispose();
    curentPass.dispose();
  }

  changePassSmartOTP(requestBody, context) async {
    BaseResponse response =
        await ChangePassWord().changePassSmartOTP(requestBody);
    if (response.errorCode == FwError.THANHCONG.value) {
      dataResponse = response.errorMessage;
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      dialogConfirm();
    } else {
      showDiaLogConfirm(
          context: context,
          content: Text(
            response.errorMessage!,
            textAlign: TextAlign.center,
          ));
    }
  }

  changePassSmsOTP(requestBody, context) async {
    BaseResponse response =
        await ChangePassWord().changePassSMSOTP(requestBody, fistLogin: false);
    if (response.errorCode == FwError.THANHCONG.value) {
      dataResponse = response.errorMessage;
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.green,
          icon: const Icon(Icons.check));
      dialogConfirm();
    } else {
      showDiaLogConfirm(
          context: context,
          content: Text(
            response.errorMessage!,
            textAlign: TextAlign.center,
          ));
    }
  }

  getChangePassCodeSmartOTP(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.UPDATEPASSWORDCODE, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    } else {
      return;
    }
  }

  getChangePassCodeSmsOTP(requestBody, language) async {
    BaseResponse response = await ChangePassWord().sendSmsOtp(requestBody);
    if (response.errorCode == '0') {
      setState(() {
        getCodeSMS = true;
      });
    } else if (mounted) {
      showToast(
          context: context,
          msg: response.errorMessage!,
          color: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

  verifyChangePass(context) async {
    final currentUser =
        LoginResponse.fromJson(localStorage.getItem('currentUser'));
    if (formKeyPass.currentState!.validate() &&
        formKeyNewPass.currentState!.validate() &&
        formKeyCurentPass.currentState!.validate()) {
      var register =
          Provider.of<OtpProvider>(context, listen: false).isRegister;
      if (register) {
        var codeGenSmartOTP =
            await getChangePassCodeSmartOTP(currentUser.username, context);

        if (codeGenSmartOTP != null) {
          OtpFunction().showDialogEnterPinOTP(
              context: context,
              transCode: codeGenSmartOTP,
              callBack: (String otp, String code) async {
                var requestBody = {
                  'otp': otp,
                  'code': code,
                  'data': {
                    "currentPass": oldPass.text,
                    "newPass": newPass.text,
                    "confirmNewPass": curentPass.text
                  }
                };
                await changePassSmartOTP(requestBody, context);
              });
        }
      } else {
        var currentLocale = await getLocale();
        var phone =
            Provider.of<CustInfoProvider>(context, listen: false).item?.tel;
        var requestBody = {
          "phone": phone,
          "language": currentLocale.languageCode.toUpperCase()
        };

        await getChangePassCodeSmsOTP(requestBody, currentLocale);
        if (getCodeSMS) {
          OtpFunction().showDialogEnterSmsOTP(
              context: context,
              callBack: (otp) async {
                var requestBody = {
                  'otp': otp,
                  'phone': phone,
                  'data': {
                    "currentPass": oldPass.text,
                    "newPass": newPass.text,
                    "confirmNewPass": curentPass.text
                  }
                };
                await changePassSmsOTP(requestBody, context);
              });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        centerTitle: true,
        toolbarHeight: 55,
        flexibleSpace: Image.asset(
          'assets/images/backgroungAppbar.png',
          fit: BoxFit.cover,
        ),
      ),
      body: renderBodyDoiMaiKhau(),
    );
  }

  renderBodyDoiMaiKhau() {
    return Consumer<SpecialCharactersProvider>(
      builder: ((context, specialCharacters, child) {
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
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "Quý khách vui lòng cung cấp các thông tin để lập lại mật khẩu truy cập",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Form(
                            key: formKeyPass,
                            child: FormControlWidget(
                              label: 'Mật khẩu hiện tại',
                              child: TextFormField(
                                obscureText: viewOldPass,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: oldPass,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 12.0,
                                      bottom: 12.0),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: Color(0xFFC0C2C3),
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    gapPadding: 1.0,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    gapPadding: 1.0,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        viewOldPass = !viewOldPass;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12, right: 14),
                                      child: viewOldPass == true
                                          ? Icon(
                                              Icons.visibility_outlined,
                                              color: colorBlack_727374
                                                  .withOpacity(0.5),
                                            )
                                          : Icon(Icons.visibility_off,
                                              color: colorBlack_727374
                                                  .withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Form(
                            key: formKeyNewPass,
                            child: InputFormWidget(
                              validator: ValidateForm(
                                      context: context,
                                      specialCharacters: specialCharacters.item)
                                  .validatePass,
                              controller: newPass,
                              obscureText: viewNewPass,
                              label: "Mật khẩu mới",
                              note: false,
                              hintText: "",
                              readOnly: false,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    viewNewPass = !viewNewPass;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, right: 14),
                                  child: viewNewPass == true
                                      ? Icon(
                                          Icons.visibility_outlined,
                                          color: colorBlack_727374
                                              .withOpacity(0.5),
                                        )
                                      : Icon(Icons.visibility_off,
                                          color: colorBlack_727374
                                              .withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Form(
                            key: formKeyCurentPass,
                            child: InputFormWidget(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Mật khẩu không được để trống";
                                } else {
                                  if (value.compareTo(newPass.text) == 0) {
                                    return null;
                                  }
                                  return "Mật khẩu xác nhận không đúng!";
                                }
                              },
                              controller: curentPass,
                              obscureText: viewCurentPass,
                              label: "Xác nhận lại mật khẩu mới",
                              note: false,
                              hintText: "",
                              readOnly: false,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    viewCurentPass = !viewCurentPass;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, right: 14),
                                  child: viewCurentPass == true
                                      ? Icon(
                                          Icons.visibility_outlined,
                                          color: colorBlack_727374
                                              .withOpacity(0.5),
                                        )
                                      : Icon(Icons.visibility_off,
                                          color: colorBlack_727374
                                              .withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 16.0),
                      child: Text.rich(
                        TextSpan(
                            text: 'Lưu ý: ',
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: primaryColor,
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    '\n- Độ dài tối thiếu 8 ký tự bao gồm ký tự bao gồm số, chữ thường, chữ in hoa và ký tự đặc biệt${specialCharacters.item == null ? '' : ': '} ${convertString(specialCharacters.item ?? '')}.\n- Mật khẩu không chứa khoảng trắng, tiếng Việt có dấu.\n- Mật khẩu mới không được trùng với mật khẩu sử dụng gần nhất.',
                                mouseCursor: MouseCursor.uncontrolled,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              )
                            ]),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ButtonWidget(
                  backgroundColor: primaryColor,
                  onPressed: (oldPass.text.isEmpty ||
                          newPass.text.isEmpty ||
                          curentPass.text.isEmpty)
                      ? null
                      : () async {
                          verifyChangePass(context);
                        },
                  text: translation(context)!.continueKey,
                  colorText: Colors.white,
                  haveBorder: false,
                  widthButton: double.infinity),
            )
          ],
        );
      }),
    );
  }

  convertString(String value) {
    String temp = '';
    for (int i = 0; i < value.length; i++) {
      temp = temp + value[i];
      if (i < value.length - 1) {
        temp = '$temp,';
      }
    }
    return temp;
  }

  dialogConfirm() {
    showDiaLogConfirm(
        horizontal: 60,
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Đổi mật khẩu thành công!\nVui lòng đăng nhập lại với mật khẩu mới.',
            style: TextStyle(height: 1.6),
            textAlign: TextAlign.center,
          ),
        ),
        handleContinute: () {
          AuthenService.logOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginWidget()),
          );
        },
        titleButton: 'Đăng nhập',
        context: context);
  }
  // Đối với Mã quản trị: “Tài khoản quý khách đã bị khóa, đề nghị quý khách liên hệ CSKH để mở lại”;
  // Đối với Mã lập lệnh/ duyệt lệnh: “Tài khoản quý khách đã bị khóa, đề nghị quý khách liên hệ Mã quản trị mở lại”
}


// Cuong1234