// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationBalanceModel _$NotificationBalanceModelFromJson(
        Map<String, dynamic> json) =>
    NotificationBalanceModel(
      id: json['id'] as String?,
      account: json['account'] as String?,
      amount: json['amount'] as String?,
      balance: json['balance'] as String?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String?,
      isRead: json['isRead'] as String?,
      message: json['message'] as String?,
      title: json['title'] as String?,
      txnum: json['txnum'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$NotificationBalanceModelToJson(
        NotificationBalanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'balance': instance.balance,
      'createdAt': instance.createdAt,
      'account': instance.account,
      'content': instance.content,
      'message': instance.message,
      'isRead': instance.isRead,
      'txnum': instance.txnum,
      'type': instance.type,
    };
