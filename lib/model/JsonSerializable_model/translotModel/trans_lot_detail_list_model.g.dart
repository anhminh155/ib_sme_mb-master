// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_lot_detail_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslotDetailListModel _$TranslotDetailListModelFromJson(
        Map<String, dynamic> json) =>
    TranslotDetailListModel(
      json['amount'] as String?,
      json['fee'] as String?,
      json['sendAccount'] as String?,
      json['status'] as String?,
      json['total'] as String?,
      (json['transLotDetails'] as List<dynamic>?)
          ?.map((e) => TranslotDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int,
    );

Map<String, dynamic> _$TranslotDetailListModelToJson(
        TranslotDetailListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'fee': instance.fee,
      'sendAccount': instance.sendAccount,
      'status': instance.status,
      'total': instance.total,
      'transLotDetails': instance.transLotDetails,
    };
