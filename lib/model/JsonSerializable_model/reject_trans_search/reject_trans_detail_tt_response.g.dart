// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_trans_detail_tt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectTransDetailTTResponse _$RejectTransDetailTTResponseFromJson(
        Map<String, dynamic> json) =>
    RejectTransDetailTTResponse(
      json['createdByCust'] as Map<String, dynamic>?,
      json['approvedBy'] as Map<String, dynamic>?,
      json['approvedDate'] as String?,
      json['ccy'] as String?,
      json['content'] as String?,
      json['feeType'] as String?,
      json['paymentStatus'] as String?,
      json['receiveAccount'] as String?,
      json['receiveBank'] as String?,
      json['receiveBankCode'] as String?,
      json['receiveName'] as String?,
      json['sendAccount'] as String?,
      json['sendName'] as String?,
      json['status'] as String?,
      json['type'] as String?,
      json['username'] as String?,
      json['vat'] as String?,
      json['reason'] as String?,
      json['transType'] as String?,
      json['code'] as String?,
      json['amount'] as String?,
      json['fee'] as String?,
      json['createdAt'] as String?,
    );

Map<String, dynamic> _$RejectTransDetailTTResponseToJson(
        RejectTransDetailTTResponse instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'createdByCust': instance.createdByCust,
      'code': instance.code,
      'amount': instance.amount,
      'approvedBy': instance.approvedBy,
      'approvedDate': instance.approvedDate,
      'ccy': instance.ccy,
      'content': instance.content,
      'fee': instance.fee,
      'feeType': instance.feeType,
      'paymentStatus': instance.paymentStatus,
      'receiveAccount': instance.receiveAccount,
      'receiveBank': instance.receiveBank,
      'receiveBankCode': instance.receiveBankCode,
      'receiveName': instance.receiveName,
      'sendAccount': instance.sendAccount,
      'sendName': instance.sendName,
      'status': instance.status,
      'type': instance.type,
      'username': instance.username,
      'vat': instance.vat,
      'reason': instance.reason,
      'transType': instance.transType,
    };
