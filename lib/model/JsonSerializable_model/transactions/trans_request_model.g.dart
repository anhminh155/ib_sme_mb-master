// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    TransactionRequest(
      json['otp'] as String,
      json['code'] as String,
      Transaction.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionRequestToJson(TransactionRequest instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'code': instance.code,
      'data': instance.data,
    };
