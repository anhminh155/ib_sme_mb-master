// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfeeRequest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransfeeRequest _$TransfeeRequestFromJson(Map<String, dynamic> json) =>
    TransfeeRequest(
      amount: json['amount'] as String,
      feeType: json['feeType'] as String,
      type: json['type'] as String,
      stt: json['stt'] as int?,
    );

Map<String, dynamic> _$TransfeeRequestToJson(TransfeeRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'feeType': instance.feeType,
      'type': instance.type,
      'stt': instance.stt,
    };
