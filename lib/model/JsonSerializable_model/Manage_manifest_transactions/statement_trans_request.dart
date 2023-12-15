import 'package:json_annotation/json_annotation.dart';
part 'statement_trans_request.g.dart';

@JsonSerializable()
class StatementTransRequest {
  late String? sendAccount;
  late dynamic status;
  late String? startDate;
  late String? approvedStartDate;
  late String? approvedEndDate;
  late String? endDate;
  late String? sendApprovedBy;
  late String? updatedByCust;
  late String? approvedBy;
  late String? transLotCode;
  late String? startAmount;
  late String? endAmount;

  StatementTransRequest(
      {this.sendAccount,
      this.status,
      this.startDate,
      this.endDate,
      this.approvedStartDate,
      this.approvedEndDate,
      this.sendApprovedBy,
      this.updatedByCust,
      this.approvedBy,
      this.transLotCode,
      this.startAmount,
      this.endAmount});

  factory StatementTransRequest.fromJson(Map<String, dynamic> json) =>
      _$StatementTransRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StatementTransRequestToJson(this);
}
