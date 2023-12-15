// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_transfer_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StmTransferRequest _$StmTransferRequestFromJson(Map<String, dynamic> json) =>
    StmTransferRequest(
      sort: json['sort'] as String,
      page: json['page'] as int,
      size: json['size'] as int,
      status: json['status'] as int?,
      sendAccount: json['sendAccount'] as String?,
      transLotCode: json['transLotCode'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startAmount: json['startAmount'] as String?,
      endAmount: json['endAmount'] as String?,
      custCode: json['custCode'] as String?,
    );

Map<String, dynamic> _$StmTransferRequestToJson(StmTransferRequest instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'page': instance.page,
      'size': instance.size,
      'sendAccount': instance.sendAccount,
      'custCode': instance.custCode,
      'transLotCode': instance.transLotCode,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startAmount': instance.startAmount,
      'endAmount': instance.endAmount,
      'status': instance.status,
    };
