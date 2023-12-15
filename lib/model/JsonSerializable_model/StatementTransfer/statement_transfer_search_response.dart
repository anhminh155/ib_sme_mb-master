import 'package:ib_sme_mb_view/model/model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'statement_transfer_search_response.g.dart';

@JsonSerializable()
class StmTransferResponse {
  String? createdAt;
  String? updatedAt;
  Cust? createdByCust;
  Cust? updatedByCust;
  String? code;
  String? amount;
  Cust? approveBy;
  String? approvedDate;
  String? branch;
  String? content;
  Cust? custId;
  String? fee;
  String? sendAccount;
  String? status;
  String? total;
  String? transDate;
  String? transDateTime;
  String? transTime;
  String? reason;
  String? transLotStatus;
  String? username;
  String? fileName;
  String? paymentDes;
  String? feeType;
  String? transLotCode;
  Cust? sendApprovedBy;
  String? sendApprovedAt;
  String? vat;

  StmTransferResponse(
      this.createdAt,
      this.updatedAt,
      this.createdByCust,
      this.updatedByCust,
      this.approveBy,
      this.code,
      this.amount,
      this.content,
      this.fee,
      this.sendAccount,
      this.status,
      this.total,
      this.transLotStatus,
      this.username,
      this.fileName,
      this.paymentDes,
      this.feeType,
      this.transLotCode,
      this.custId,
      this.sendApprovedAt,
      this.sendApprovedBy,
      this.transDate,
      this.approvedDate,
      this.branch,
      this.reason,
      this.transDateTime,
      this.transTime,
      this.vat);
  factory StmTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$StmTransferResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StmTransferResponseToJson(this);
}
