// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_restore_pin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRestorePinRequest _$OtpRestorePinRequestFromJson(
        Map<String, dynamic> json) =>
    OtpRestorePinRequest(
      otpTokenId: json['otpTokenId'] as String,
      smsOtpCode: json['smsOtpCode'] as String,
      pin: json['pin'] as String,
    );

Map<String, dynamic> _$OtpRestorePinRequestToJson(
        OtpRestorePinRequest instance) =>
    <String, dynamic>{
      'otpTokenId': instance.otpTokenId,
      'smsOtpCode': instance.smsOtpCode,
      'pin': instance.pin,
    };
