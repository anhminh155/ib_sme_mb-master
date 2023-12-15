// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'reportTransfee_request.g.dart';

@JsonSerializable()
class ReportTransfeeRequest {
  final String account;
  final String batdau;
  final String kethuc;
  ReportTransfeeRequest(this.batdau, this.kethuc, this.account);
  factory ReportTransfeeRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportTransfeeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ReportTransfeeRequestToJson(this);
}
