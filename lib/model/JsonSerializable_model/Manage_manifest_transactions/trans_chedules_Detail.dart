// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'trans_chedules_Detail.g.dart';

@JsonSerializable()
class TransLotDetailDto {
  int? id;
  String? code;
  String? amount;
  // CustDto? approvedBy;
  String? approvedDat;
  String? ccy;
  String? fee;
  String? paymentStatus;
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
  String? transDate;
  String? transDatetime;
  String? transTime;
  String? txnum;
  String? type;
  String? vat;
  String? content;
  String? status;
  String? paymentErrorMes;
  // TransLotDto transLot;

  TransLotDetailDto({
    this.id,
    this.code,
    this.amount,
    this.approvedDat,
    this.ccy,
    this.fee,
    this.paymentStatus,
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
    this.transDate,
    this.transDatetime,
    this.transTime,
    this.txnum,
    this.type,
    this.vat,
    this.content,
    this.status,
    this.paymentErrorMes,
  });

  factory TransLotDetailDto.fromJson(Map<String, dynamic> json) =>
      _$TransLotDetailDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TransLotDetailDtoToJson(this);
}
