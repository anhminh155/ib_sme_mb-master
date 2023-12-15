// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_transfer_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StmTransferResponse _$StmTransferResponseFromJson(Map<String, dynamic> json) =>
    StmTransferResponse(
      json['createdAt'] as String?,
      json['updatedAt'] as String?,
      json['createdByCust'] == null
          ? null
          : Cust.fromJson(json['createdByCust'] as Map<String, dynamic>),
      json['updatedByCust'] == null
          ? null
          : Cust.fromJson(json['updatedByCust'] as Map<String, dynamic>),
      json['approveBy'] == null
          ? null
          : Cust.fromJson(json['approveBy'] as Map<String, dynamic>),
      json['code'] as String?,
      json['amount'] as String?,
      json['content'] as String?,
      json['fee'] as String?,
      json['sendAccount'] as String?,
      json['status'] as String?,
      json['total'] as String?,
      json['transLotStatus'] as String?,
      json['username'] as String?,
      json['fileName'] as String?,
      json['paymentDes'] as String?,
      json['feeType'] as String?,
      json['transLotCode'] as String?,
      json['custId'] == null
          ? null
          : Cust.fromJson(json['custId'] as Map<String, dynamic>),
      json['sendApprovedAt'] as String?,
      json['sendApprovedBy'] == null
          ? null
          : Cust.fromJson(json['sendApprovedBy'] as Map<String, dynamic>),
      json['transDate'] as String?,
      json['approvedDate'] as String?,
      json['branch'] as String?,
      json['reason'] as String?,
      json['transDateTime'] as String?,
      json['transTime'] as String?,
      json['vat'] as String?,
    );

Map<String, dynamic> _$StmTransferResponseToJson(
        StmTransferResponse instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'createdByCust': instance.createdByCust,
      'updatedByCust': instance.updatedByCust,
      'code': instance.code,
      'amount': instance.amount,
      'approveBy': instance.approveBy,
      'approvedDate': instance.approvedDate,
      'branch': instance.branch,
      'content': instance.content,
      'custId': instance.custId,
      'fee': instance.fee,
      'sendAccount': instance.sendAccount,
      'status': instance.status,
      'total': instance.total,
      'transDate': instance.transDate,
      'transDateTime': instance.transDateTime,
      'transTime': instance.transTime,
      'reason': instance.reason,
      'transLotStatus': instance.transLotStatus,
      'username': instance.username,
      'fileName': instance.fileName,
      'paymentDes': instance.paymentDes,
      'feeType': instance.feeType,
      'transLotCode': instance.transLotCode,
      'sendApprovedBy': instance.sendApprovedBy,
      'sendApprovedAt': instance.sendApprovedAt,
      'vat': instance.vat,
    };
