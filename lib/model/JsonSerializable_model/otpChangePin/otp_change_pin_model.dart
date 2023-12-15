import 'package:json_annotation/json_annotation.dart';
part 'otp_change_pin_model.g.dart';

@JsonSerializable()
class OtpChangePinRequest {
  final String otpTokenId;
  final String oldPin;
  final String pin;

  OtpChangePinRequest(
      {required this.otpTokenId, required this.oldPin, required this.pin});

  factory OtpChangePinRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpChangePinRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OtpChangePinRequestToJson(this);
}
