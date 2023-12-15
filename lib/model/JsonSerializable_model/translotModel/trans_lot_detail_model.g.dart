// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_lot_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslotDetailModel _$TranslotDetailModelFromJson(Map<String, dynamic> json) =>
    TranslotDetailModel(
      json['id'] as int?,
      json['amount'] as String?,
      json['ccy'] as String?,
      json['fee'] as String?,
      json['paymentStatus'] as String?,
      json['receiveAccount'] as String?,
      json['receiveBank'] as String?,
      json['receiveName'] as String?,
      json['type'] as String?,
      json['content'] as String?,
      json['status'] as String?,
      json['createdAt'] as String?,
      json['updatedAt'] as String?,
      json['code'] as String?,
      json['vat'] as String?,
    );

Map<String, dynamic> _$TranslotDetailModelToJson(
        TranslotDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'amount': instance.amount,
      'ccy': instance.ccy,
      'fee': instance.fee,
      'vat': instance.vat,
      'code': instance.code,
      'paymentStatus': instance.paymentStatus,
      'receiveAccount': instance.receiveAccount,
      'receiveBank': instance.receiveBank,
      'receiveName': instance.receiveName,
      'type': instance.type,
      'content': instance.content,
      'status': instance.status,
    };
