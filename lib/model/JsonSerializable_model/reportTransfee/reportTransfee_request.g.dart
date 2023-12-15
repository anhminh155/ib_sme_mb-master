// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportTransfee_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportTransfeeRequest _$ReportTransfeeRequestFromJson(
        Map<String, dynamic> json) =>
    ReportTransfeeRequest(
      json['batdau'] as String,
      json['kethuc'] as String,
      json['account'] as String,
    );

Map<String, dynamic> _$ReportTransfeeRequestToJson(
        ReportTransfeeRequest instance) =>
    <String, dynamic>{
      'account': instance.account,
      'batdau': instance.batdau,
      'kethuc': instance.kethuc,
    };
