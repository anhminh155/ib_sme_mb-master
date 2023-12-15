// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';
import 'package:ib_sme_mb_view/common/dialog_confirm.dart';
import 'package:ib_sme_mb_view/common/form/form_control.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/form_input.dart';
import 'package:ib_sme_mb_view/common/loading_circle.dart';
import 'package:ib_sme_mb_view/common/validate_form.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/change_pass.dart';
import 'package:ib_sme_mb_view/network/services/get_code_gen_otp_service.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';
import 'package:ib_sme_mb_view/provider/providers.dart';
import 'package:provider/provider.dart';
import '../../../utils/theme.dart';

class ChangeFirstPassword extends StatefulWidget {
  const ChangeFirstPassword({super.key});

  @override
  State<ChangeFirstPassword> createState() => _ChangeFirstPasswordState();
}

class _ChangeFirstPasswordState extends State<ChangeFirstPassword>
    with BaseComponent {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final curentPass = TextEditingController();
  late bool viewOldPass = true;
  late bool viewNewPass = true;
  late bool viewCurentPass = true;
  late bool statusValid = false;
  late int passNotCorrect = 3;
  final formKeyPass = GlobalKey<FormState>();
  final formKeyNewPass = GlobalKey<FormState>();
  final formKeyCurentPass = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    oldPass.dispose();
    newPass.dispose();
    curentPass.dispose();
  }

  _changePass() async {
    setState(() => _isLoading = true);
    try {
      var request = {
        "currentPass": oldPass.text,
        "newPass": newPass.text,
        "confirmNewPass": newPass.text,
      };
      BaseResponse response = await ChangePassWord().changePassSMSOTP(request);
      if (response.errorCode == FwError.THANHCONG.value) {
        Navigator.of(context).pop(true);
      } else {
        showDiaLogConfirm(
            content: Text(
              response.errorMessage!,
              textAlign: TextAlign.center,
            ),
            context: context);
      }
    } catch (e) {
      showDiaLogConfirm(content: Text(e.toString()), context: context);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  getChangePassCode(code, context) async {
    BaseResponse response =
        await GetCodeGenOTP().getCodeGenOTP(TypeCode.UPDATEPASSWORDCODE, code);
    if (response.errorCode == FwError.THANHCONG.value) {
      return response.data;
    } else {
      return;
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
      body: Stack(
        children: [
          renderBodyDoiMaiKhau(),
          if (_isLoading) const LoadingCircle()
        ],
      ),
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
                                    '\n- Độ dài tối thiếu 8 ký tự bao gồm ký tự bao gồm số, chữ thường, chữ in hoa và ký tự đặc biệt: ${convertString(specialCharacters.item ?? "")}.\n- Mật khẩu không chứa khoảng trắng, tiếng Việt có dấu.\n- Mật khẩu mới không được trùng với mật khẩu sử dụng gần nhất.',
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
                  onPressed: _changePass,
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

  // Đối với Mã quản trị: “Tài khoản quý khách đã bị khóa, đề nghị quý khách liên hệ CSKH để mở lại”;
  // Đối với Mã lập lệnh/ duyệt lệnh: “Tài khoản quý khách đã bị khóa, đề nghị quý khách liên hệ Mã quản trị mở lại”
}


// Cuong1234