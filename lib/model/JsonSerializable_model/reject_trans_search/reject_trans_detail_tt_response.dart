import 'package:json_annotation/json_annotation.dart';
part 'reject_trans_detail_tt_response.g.dart';

@JsonSerializable()
class RejectTransDetailTTResponse {
  final String? createdAt;
  final Map<String, dynamic>? createdByCust;
  final String? code;
  final String? amount;
  final Map<String, dynamic>? approvedBy;
  final String? approvedDate;
  final String? ccy;
  final String? content;
  final String? fee;
  final String? feeType;
  final String? paymentStatus;
  final String? receiveAccount;
  final String? receiveBank;
  final String? receiveBankCode;
  final String? receiveName;
  final String? sendAccount;
  final String? sendName;
  final String? status;
  final String? type;
  final String? username;
  final String? vat;
  final String? reason;
  final String? transType;
  RejectTransDetailTTResponse(
      this.createdByCust,
      this.approvedBy,
      this.approvedDate,
      this.ccy,
      this.content,
      this.feeType,
      this.paymentStatus,
      this.receiveAccount,
      this.receiveBank,
      this.receiveBankCode,
      this.receiveName,
      this.sendAccount,
      this.sendName,
      this.status,
      this.type,
      this.username,
      this.vat,
      this.reason,
      this.transType,
      this.code,
      this.amount,
      this.fee,
      this.createdAt);
  factory RejectTransDetailTTResponse.fromJson(Map<String, dynamic> json) =>
      _$RejectTransDetailTTResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RejectTransDetailTTResponseToJson(this);
}
