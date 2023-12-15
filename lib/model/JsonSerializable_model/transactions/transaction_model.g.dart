// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      transType: json['transType'] as String?,
      amount: json['amount'] as String,
      content: json['content'] as String,
      fee: json['fee'] as String,
      vat: json['vat'] as String,
      sendAccount: json['sendAccount'] as String,
      receiveAccount: json['receiveAccount'] as String,
      receiveName: json['receiveName'] as String,
      type: json['type'] as String,
      feeType: json['feeType'] as int,
      receiveBank: json['receiveBank'] as String,
      receiveBankCode: json['receiveBankCode'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transType': instance.transType,
      'amount': instance.amount,
      'content': instance.content,
      'fee': instance.fee,
      'vat': instance.vat,
      'sendAccount': instance.sendAccount,
      'receiveAccount': instance.receiveAccount,
      'receiveName': instance.receiveName,
      'type': instance.type,
      'feeType': instance.feeType,
      'receiveBank': instance.receiveBank,
      'receiveBankCode': instance.receiveBankCode,
    };
