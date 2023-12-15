// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'transfeeRequest_model.g.dart';

@JsonSerializable()
class TransfeeRequest {
  final String amount;
  final String feeType;
  final String type;
  final int? stt;

  factory TransfeeRequest.fromJson(Map<String, dynamic> json) =>
      _$TransfeeRequestFromJson(json);

  TransfeeRequest(
      {required this.amount,
      required this.feeType,
      required this.type,
      required this.stt});
  Map<String, dynamic> toJson() => _$TransfeeRequestToJson(this);
}
