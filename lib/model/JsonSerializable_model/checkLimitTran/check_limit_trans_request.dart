import 'package:json_annotation/json_annotation.dart';

part 'check_limit_trans_request.g.dart';

@JsonSerializable()
class CheckLimitTransRequest {
  final String amount;
  final String fee;
  final String type;
  final String vat;

  CheckLimitTransRequest(
      {required this.amount,
      required this.fee,
      required this.type,
      required this.vat});

  factory CheckLimitTransRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckLimitTransRequestFromJson(json);  Map<String, dynamic> toJson() => _$CheckLimitTransRequestToJson(this);
}
