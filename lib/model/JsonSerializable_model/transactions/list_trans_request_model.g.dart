// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_trans_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransactionRequest _$ListTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    ListTransactionRequest(
      json['otp'] as String,
      json['code'] as String,
      (json['data'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListTransactionRequestToJson(
        ListTransactionRequest instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'code': instance.code,
      'data': instance.data,
    };
