// ignore_for_file: file_names
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transSchedule.g.dart';

@JsonSerializable()
class TransScheduleModel {
  String? createdAt;
  String? updatedAt;
  Cust? createdByCust;
  Cust? updatedByCust;
  String? code;
  String? amount;
  Cust? approvedBy;
  String? approvedDate;
  String? balance;
  String? branch;
  String? ccy;
  String? content;
  dynamic custId;
  String? fee;
  String? feeType;
  String? receiveBankCode;
  String? receiveAccount;
  String? receiveBank;
  String? receiveName;
  String? sendAccount;
  String? sendName;
  String? status;
  String? transDate;
  String? transDatetime;
  String? transTime;
  String? txnum;
  String? type;
  String? username;
  String? vat;
  dynamic schedules;
  String? schedulesFromDate;
  String? schedulesToDate;
  dynamic schedulesFrequency;
  dynamic schedulesTimes;
  String? reason;
  String? schedulesFuture;
  TransScheduleModel({
    this.createdAt,
    this.updatedAt,
    this.createdByCust,
    this.updatedByCust,
    this.code,
    this.amount,
    this.balance,
    this.approvedBy,
    this.approvedDate,
    this.branch,
    this.ccy,
    this.content,
    this.custId,
    this.fee,
    // this.receiveBankCode,
    this.receiveAccount,
    this.receiveBank,
    this.receiveName,
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
    this.schedules,
    this.schedulesFromDate,
    this.schedulesToDate,
    this.schedulesFrequency,
    this.schedulesTimes,
    this.feeType,
    this.reason,
  });
  factory TransScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$TransScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransScheduleModelToJson(this);
}
