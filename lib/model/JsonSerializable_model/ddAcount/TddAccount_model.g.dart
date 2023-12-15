// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TddAccount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TDDAcount _$TDDAcountFromJson(Map<String, dynamic> json) => TDDAcount(
      curbalance: (json['curbalance'] as num?)?.toDouble(),
      acctno: json['acctno'] as String?,
      actype: json['actype'] as String?,
      ccycd: json['ccycd'] as String?,
      lastdate: json['lastdate'] as String?,
      custid: json['custid'] as String?,
      status: json['status'] as String?,
      balance: json['balance'] as String?,
      dbegbal: json['dbegbal'] as int?,
      crintacr: json['crintacr'] as int?,
      emkamt: json['emkamt'] as int?,
      mcredit: json['mcredit'] as int?,
      mdebit: json['mdebit'] as int?,
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$TDDAcountToJson(TDDAcount instance) => <String, dynamic>{
      'acctno': instance.acctno,
      'actype': instance.actype,
      'ccycd': instance.ccycd,
      'lastdate': instance.lastdate,
      'custid': instance.custid,
      'status': instance.status,
      'balance': instance.balance,
      'dbegbal': instance.dbegbal,
      'crintacr': instance.crintacr,
      'emkamt': instance.emkamt,
      'mcredit': instance.mcredit,
      'mdebit': instance.mdebit,
      'remark': instance.remark,
      'curbalance': instance.curbalance,
    };
