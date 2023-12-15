// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_tranfer_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StmTransferDetailRequest _$StmTransferDetailRequestFromJson(
        Map<String, dynamic> json) =>
    StmTransferDetailRequest(
      sort: json['sort'] as String,
      page: json['page'] as int,
      size: json['size'] as int,
      transLot: json['transLot'] as String?,
    );

Map<String, dynamic> _$StmTransferDetailRequestToJson(
        StmTransferDetailRequest instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'page': instance.page,
      'size': instance.size,
      'transLot': instance.transLot,
    };
