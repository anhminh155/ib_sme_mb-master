// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/network/services/languages_service.dart';

class ValidateForm {
  final String? specialCharacters;
  final BuildContext context;
  ValidateForm({this.specialCharacters, required this.context});
  String? validateText(String? value) {
    if (value!.isEmpty) {
      return 'Tên không được để trống!';
    } else if (!RegExp(
            r'^[a-z A-Z ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳýỵỷỹ]+$')
        .hasMatch(value)) {
      return 'Tên không được chứa chữ số hay ký tự đặc biệt!';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return translation(context)!.could_not_be_empty("Email");
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Email không đúng định dạng abc@def.xyz !';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return translation(context)!
          .could_not_be_empty(translation(context)!.phonenumberKey);
    } else if (!RegExp(r'([84|0][2|3|5|7|8|9])+([0-9]{8})\b').hasMatch(value)) {
      return 'Số điện thoại không đúng!';
    } else {
      return null;
    }
  }

  String? validateNullPhoneNumber(String? value) {
    if (value!.isEmpty) {
      return translation(context)!
          .could_not_be_empty(translation(context)!.phonenumberKey);
    } else {
      return null;
    }
  }

  String? validateUserName(String? value) {
    if (value!.isEmpty) {
      return translation(context)!
          .could_not_be_empty(translation(context)!.usernameKey);
    } else if (!RegExp(r'^[a-zA-Z0-9\+]*$').hasMatch(value)) {
      return 'Tên đăng nhập không được chứa ký tự đặc biệt!';
    } else {
      return null;
    }
  }

  String? validatePass(String? value) {
    if (value!.isEmpty || value == '') {
      return translation(context)!
          .could_not_be_empty(translation(context)!.passwordKey);
    } else if (value.length < 8) {
      return "Mật khẩu phải có 8 ký tự trở lên!";
    } else if (specialCharacters != null &&
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[' +
                specialCharacters! +
                ']).{7,20}')
            .hasMatch(value)) {
      return "Mật khẩu không thỏa mãn điều kiện";
    } else {
      return null;
    }
  }

  String? validateAmount(String value, double amount) {
    if (value.isNotEmpty) {
      if (double.parse(value) > amount) {
        return 'Số tiền giao dịch không hơp lệ';
      }
    } else {
      return 'Vui lòng nhập số tiền';
    }
    return null;
  }
}
