// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportTransfee_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportTransfeeResponse _$ReportTransfeeResponseFromJson(
        Map<String, dynamic> json) =>
    ReportTransfeeResponse(
      (json['amount'] as num).toDouble(),
      (json['fee'] as num).toDouble(),
      json['list'],
    );

Map<String, dynamic> _$ReportTransfeeResponseToJson(
        ReportTransfeeResponse instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'fee': instance.fee,
      'list': instance.list,
    };
