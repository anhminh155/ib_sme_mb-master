// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_trans_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectTransResponse _$RejectTransResponseFromJson(Map<String, dynamic> json) =>
    RejectTransResponse(
      json['code'] as String?,
      json['amount'] as String?,
      json['receiveName'] as String?,
      json['type'] as String?,
      json['schedules'] as int?,
    );

Map<String, dynamic> _$RejectTransResponseToJson(
        RejectTransResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'amount': instance.amount,
      'receiveName': instance.receiveName,
      'type': instance.type,
      'schedules': instance.schedules,
    };
