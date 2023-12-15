// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'TddAccount_model.g.dart';

@JsonSerializable()
class TDDAcount {
  final String? acctno;
  final String? actype;
  final String? ccycd;
  final String? lastdate;
  final String? custid;
  final String? status;
  final String? balance;
  final int? dbegbal;
  final int? crintacr;
  final int? emkamt;
  final int? mcredit;
  final int? mdebit;
  final String? remark;
  final double? curbalance;

  TDDAcount({
    this.curbalance,
    this.acctno,
    this.actype,
    this.ccycd,
    this.lastdate,
    this.custid,
    this.status,
    this.balance,
    this.dbegbal,
    this.crintacr,
    this.emkamt,
    this.mcredit,
    this.mdebit,
    this.remark,
  });
  factory TDDAcount.fromJson(Map<String, dynamic> json) =>
      _$TDDAcountFromJson(json);
  Map<String, dynamic> toJson() => _$TDDAcountToJson(this);
}
