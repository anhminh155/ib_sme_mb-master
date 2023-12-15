import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/text_field.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';

import '../utils/theme.dart';

Future<void> showDiaLogConfirm(
    {BuildContext? context,
    double? horizontal,
    Function? handleContinute,
    String? title,
    Widget? content,
    String? note,
    bool? close,
    Color? colorButton,
    String? titleButton}) {
  TextEditingController controllerReason = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog(
    barrierDismissible: false,
    context: context!,
    builder: (BuildContext contextDialog) {
      return Dialog(
        shadowColor: Colors.black,
        insetPadding: EdgeInsets.symmetric(horizontal: horizontal ?? 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo1.svg',
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      title ?? "Thông báo",
                      style: const TextStyle(color: primaryColor, fontSize: 22),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  close == true
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(contextDialog);
                            controllerReason.dispose();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 22,
                          ))
                      : const SizedBox(),
                ],
              ),
              if (content != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: content,
                ),
              if (note != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Form(
                    key: formKey,
                    child: TextFieldWidget(
                      hintText: "Nhập lý do",
                      maxLines: 4,
                      readOnly: false,
                      controller: controllerReason,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return note;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              InkWell(
                onTap: note != null
                    ? () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(contextDialog);
                          handleContinute!(controllerReason.text);
                        }
                      }
                    : () {
                        Navigator.pop(contextDialog);
                        if (handleContinute != null) {
                          handleContinute();
                        }
                      },
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: colorButton ?? primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Text(
                          titleButton ?? translation(context)!.continueKey,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
