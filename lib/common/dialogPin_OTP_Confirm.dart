// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/button.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/theme.dart';

// ignore: use_key_in_widget_constructors

class DialogPinOtpConfirm extends StatefulWidget {
  final TextEditingController? controller;
  final String? phoneNumber;
  final Widget? title;
  final String? titleButton;
  final bool? note;
  final Widget? content;
  final Function handleClickButton;
  final int? length;
  final bool? obscureText;

  const DialogPinOtpConfirm({
    Key? key,
    this.phoneNumber,
    this.title,
    this.note,
    this.length,
    this.content,
    this.titleButton,
    this.controller,
    this.obscureText,
    required this.handleClickButton,
  })  : assert((content == null && length != null) ||
            (content != null && length == null)),
        super(key: key);

  @override
  DialogPinOtpConfirmState createState() => DialogPinOtpConfirmState();
}

class DialogPinOtpConfirmState extends State<DialogPinOtpConfirm> {
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150, maxHeight: 300),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (widget.content != null) ? 16.0 : 25.0,
                  vertical: 16.0),
              child: Wrap(
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                children: [
                  widget.title!,
                  const SizedBox(
                    height: 10.0,
                    width: double.infinity,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: (widget.content != null)
                          ? widget.content!
                          : Form(
                              key: formKey,
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                dialogConfig: DialogConfig(
                                  affirmativeText: "Đồng ý",
                                  negativeText: "Đóng",
                                  dialogContent: "Bạn có muốn dán ",
                                  dialogTitle: "Thông báo",
                                ),
                                length: widget.length!,
                                obscureText: widget.obscureText ?? true,
                                blinkWhenObscuring: true,
                                cursorHeight: 12,
                                textStyle: const TextStyle(fontSize: 14),
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5.0),
                                    fieldHeight: 40,
                                    fieldWidth: 30,
                                    borderWidth: 1.0,
                                    inactiveColor: colorBlack_15334A,
                                    activeFillColor: Colors.white,
                                    selectedColor: secondaryColor,
                                    activeColor: primaryColor),
                                cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: false,
                                errorAnimationController: errorController,
                                controller: widget.controller,
                                keyboardType: TextInputType.number,
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    currentText = value;
                                  });
                                },
                              ),
                            ),
                    ),
                  ),
                  if ((widget.note ?? false) == true)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Lưu ý: Smart OTP sẽ bị khóa nếu Quý khách nhập sai mật khẩu 5 lần liên tiếp",
                            style: TextStyle(
                                color: colorBlack_727374.withOpacity(0.6),
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: (widget.content == null) ? 10.0 : 15.0,
                    width: double.infinity,
                  ),
                  ButtonWidget(
                      height: 40,
                      backgroundColor: primaryColor,
                      onPressed: (widget.content == null)
                          ? (currentText.length == widget.length ||
                                  widget.controller != null)
                              ? () {
                                  widget.handleClickButton(currentText);
                                }
                              : null
                          : () {
                              widget.handleClickButton();
                            },
                      text: widget.titleButton ??
                          translation(context)!.continueKey,
                      colorText: Colors.white,
                      haveBorder: false,
                      widthButton: double.infinity)
                ],
              ),
            ),
          ),
          Positioned(
            top: 5.0,
            right: 5.0,
            child: IconButton(
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 16,
                color: colorBlack_727374.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
