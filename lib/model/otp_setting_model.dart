// To parse this JSON data, do
//
//     final otpSettingModel = otpSettingModelFromJson(jsonString);

import 'dart:convert';

OtpSettingModel otpSettingModelFromJson(String str) => OtpSettingModel.fromJson(json.decode(str));

String otpSettingModelToJson(OtpSettingModel data) => json.encode(data.toJson());

class OtpSettingModel {
    final int pinFalse;
    final int betweenOtp;
    final int dateLock;

    OtpSettingModel({
        required this.pinFalse,
        required this.betweenOtp,
        required this.dateLock,
    });

    OtpSettingModel.initial():
              dateLock = 60,
              betweenOtp = 30,
              pinFalse = 5;

    OtpSettingModel copyWith({
        int? pinFalse,
        int? betweenOtp,
        int? dateLock,
    }) => 
        OtpSettingModel(
            pinFalse: pinFalse ?? this.pinFalse,
            betweenOtp: betweenOtp ?? this.betweenOtp,
            dateLock: dateLock ?? this.dateLock,
        );

    factory OtpSettingModel.fromJson(Map<String, dynamic> json) => OtpSettingModel(
        pinFalse: json["pinFalse"],
        betweenOtp: json["betweenOtp"],
        dateLock: json["dateLock"],
    );

    Map<String, dynamic> toJson() => {
        "pinFalse": pinFalse,
        "betweenOtp": betweenOtp,
        "dateLock": dateLock,
    };
}
