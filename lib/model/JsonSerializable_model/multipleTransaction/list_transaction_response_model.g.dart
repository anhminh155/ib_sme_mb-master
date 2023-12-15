// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transaction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransactionResponse _$ListTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    ListTransactionResponse(
      json['errorCode'] as String,
      json['errorMessage'] as String,
      TransactionResponse.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListTransactionResponseToJson(
        ListTransactionResponse instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'data': instance.data,
    };
