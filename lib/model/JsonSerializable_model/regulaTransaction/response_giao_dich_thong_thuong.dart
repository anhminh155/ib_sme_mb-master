import 'package:json_annotation/json_annotation.dart';

import '../../model.dart';
part 'response_giao_dich_thong_thuong.g.dart';

@JsonSerializable()
class Tran {
  String? createdAt;
  String? updatedAt;
  Cust? createdByCust;
  Cust? updatedByCust;
  String? code;
  String? amount;
  Cust? approvedBy;
  String? approvedDate;
  String? branch;
  String? ccy;
  String? content;
  int? custId;
  String? fee;
  String? balance;
  String? paymentStatus;
  String? receiveBankCode;
  String? receiveAccount;
  String? receiveBank;
  String? receiveName;
  String? reqId;
  String? resCode;
  String? resDes;
  String? resId;
  String? revertCode;
  String? revertDes;
  String? revertFeeCode;
  String? revertFeeDes;
  String? sendAccount;
  String? sendName;
  String? status;
  String? transDate;
  DateTime? transDatetime;
  String? transTime;
  String? txnum;
  String? type;
  String? username;
  String? vat;
  String? feeType;
  String? reason;
  dynamic relationNo;
  String? transType;

  Tran(
      {this.createdAt,
      this.updatedAt,
      this.createdByCust,
      this.updatedByCust,
      this.code,
      this.amount,
      this.approvedBy,
      this.approvedDate,
      this.branch,
      this.ccy,
      this.content,
      this.custId,
      this.fee,
      this.paymentStatus,
      this.receiveBankCode,
      this.receiveAccount,
      this.receiveBank,
      this.receiveName,
      this.reqId,
      this.resCode,
      this.resDes,
      this.resId,
      this.revertCode,
      this.revertDes,
      this.revertFeeCode,
      this.revertFeeDes,
      this.sendAccount,
      this.sendName,
      this.status,
      this.transDate,
      this.transDatetime,
      this.transTime,
      this.txnum,
      this.type,
      this.username,
      this.vat,
      this.feeType,
      this.reason,
      this.relationNo,
      this.transType,
      this.balance});

  factory Tran.fromJson(Map<String, dynamic> json) => _$TranFromJson(json);
  Map<String, dynamic> toJson() => _$TranToJson(this);
}
