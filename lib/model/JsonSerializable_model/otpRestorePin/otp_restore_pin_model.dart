import 'package:json_annotation/json_annotation.dart';
part 'otp_restore_pin_model.g.dart';

@JsonSerializable()
class OtpRestorePinRequest {
  final String otpTokenId;
  final String smsOtpCode;
  final String pin;

  OtpRestorePinRequest(
      {required this.otpTokenId, required this.smsOtpCode, required this.pin});

  factory OtpRestorePinRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRestorePinRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OtpRestorePinRequestToJson(this);
}
