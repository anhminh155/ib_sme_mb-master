// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfeeResponse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransfeeResponse _$TransfeeResponseFromJson(Map<String, dynamic> json) =>
    TransfeeResponse(
      stt: json['stt'] as int?,
      fee: json['fee'] as String,
      vat: json['vat'] as String,
    );

Map<String, dynamic> _$TransfeeResponseToJson(TransfeeResponse instance) =>
    <String, dynamic>{
      'stt': instance.stt,
      'fee': instance.fee,
      'vat': instance.vat,
    };
