// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      json['amount'] as String,
      json['content'] as String,
      json['fee'] as String,
      json['receiveBankCode'] as String?,
      json['sendAccount'] as String,
      json['receiveAccount'] as String,
      json['receiveBank'] as String,
      json['receiveName'] as String,
      json['custId'] as int,
      json['type'] as String,
      json['feeType'] as String,
      json['createdAt'] as String,
      json['code'] as String,
      json['status'] as String,
    );

Map<String, dynamic> _$TransactionResponseToJson(
        TransactionResponse instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'code': instance.code,
      'amount': instance.amount,
      'content': instance.content,
      'fee': instance.fee,
      'sendAccount': instance.sendAccount,
      'receiveBankCode': instance.receiveBankCode,
      'receiveAccount': instance.receiveAccount,
      'receiveBank': instance.receiveBank,
      'receiveName': instance.receiveName,
      'custId': instance.custId,
      'type': instance.type,
      'status': instance.status,
      'feeType': instance.feeType,
    };
