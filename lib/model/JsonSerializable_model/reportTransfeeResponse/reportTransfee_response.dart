// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'reportTransfee_response.g.dart';

@JsonSerializable()
class ReportTransfeeResponse {
  final double amount;
  final double fee;
  final dynamic list;
  ReportTransfeeResponse(this.amount, this.fee, this.list);
  factory ReportTransfeeResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportTransfeeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReportTransfeeResponseToJson(this);
}
