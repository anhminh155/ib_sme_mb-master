// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_limit_trans_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckLimitTransRequest _$CheckLimitTransRequestFromJson(
        Map<String, dynamic> json) =>
    CheckLimitTransRequest(
      amount: json['amount'] as String,
      fee: json['fee'] as String,
      type: json['type'] as String,
      vat: json['vat'] as String,
    );

Map<String, dynamic> _$CheckLimitTransRequestToJson(
        CheckLimitTransRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'fee': instance.fee,
      'type': instance.type,
      'vat': instance.vat,
    };
