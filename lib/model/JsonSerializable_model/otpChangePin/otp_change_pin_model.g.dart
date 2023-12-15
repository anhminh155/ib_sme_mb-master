// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_change_pin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpChangePinRequest _$OtpChangePinRequestFromJson(Map<String, dynamic> json) =>
    OtpChangePinRequest(
      otpTokenId: json['otpTokenId'] as String,
      oldPin: json['oldPin'] as String,
      pin: json['pin'] as String,
    );

Map<String, dynamic> _$OtpChangePinRequestToJson(
        OtpChangePinRequest instance) =>
    <String, dynamic>{
      'otpTokenId': instance.otpTokenId,
      'oldPin': instance.oldPin,
      'pin': instance.pin,
    };
