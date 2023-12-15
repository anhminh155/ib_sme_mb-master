// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_giao_dich_thong_thuong.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tran _$TranFromJson(Map<String, dynamic> json) => Tran(
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      createdByCust: json['createdByCust'] == null
          ? null
          : Cust.fromJson(json['createdByCust'] as Map<String, dynamic>),
      updatedByCust: json['updatedByCust'] == null
          ? null
          : Cust.fromJson(json['updatedByCust'] as Map<String, dynamic>),
      code: json['code'] as String?,
      amount: json['amount'] as String?,
      approvedBy: json['approvedBy'] == null
          ? null
          : Cust.fromJson(json['approvedBy'] as Map<String, dynamic>),
      approvedDate: json['approvedDate'] as String?,
      branch: json['branch'] as String?,
      ccy: json['ccy'] as String?,
      content: json['content'] as String?,
      custId: json['custId'] as int?,
      fee: json['fee'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      receiveBankCode: json['receiveBankCode'] as String?,
      receiveAccount: json['receiveAccount'] as String?,
      receiveBank: json['receiveBank'] as String?,
      receiveName: json['receiveName'] as String?,
      reqId: json['reqId'] as String?,
      resCode: json['resCode'] as String?,
      resDes: json['resDes'] as String?,
      resId: json['resId'] as String?,
      revertCode: json['revertCode'] as String?,
      revertDes: json['revertDes'] as String?,
      revertFeeCode: json['revertFeeCode'] as String?,
      revertFeeDes: json['revertFeeDes'] as String?,
      sendAccount: json['sendAccount'] as String?,
      sendName: json['sendName'] as String?,
      status: json['status'] as String?,
      transDate: json['transDate'] as String?,
      transDatetime: json['transDatetime'] == null
          ? null
          : DateTime.parse(json['transDatetime'] as String),
      transTime: json['transTime'] as String?,
      txnum: json['txnum'] as String?,
      type: json['type'] as String?,
      username: json['username'] as String?,
      vat: json['vat'] as String?,
      feeType: json['feeType'] as String?,
      reason: json['reason'] as String?,
      relationNo: json['relationNo'],
      transType: json['transType'] as String?,
      balance: json['balance'] as String?,
    );

Map<String, dynamic> _$TranToJson(Tran instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'createdByCust': instance.createdByCust,
      'updatedByCust': instance.updatedByCust,
      'code': instance.code,
      'amount': instance.amount,
      'approvedBy': instance.approvedBy,
      'approvedDate': instance.approvedDate,
      'branch': instance.branch,
      'ccy': instance.ccy,
      'content': instance.content,
      'custId': instance.custId,
      'fee': instance.fee,
      'balance': instance.balance,
      'paymentStatus': instance.paymentStatus,
      'receiveBankCode': instance.receiveBankCode,
      'receiveAccount': instance.receiveAccount,
      'receiveBank': instance.receiveBank,
      'receiveName': instance.receiveName,
      'reqId': instance.reqId,
      'resCode': instance.resCode,
      'resDes': instance.resDes,
      'resId': instance.resId,
      'revertCode': instance.revertCode,
      'revertDes': instance.revertDes,
      'revertFeeCode': instance.revertFeeCode,
      'revertFeeDes': instance.revertFeeDes,
      'sendAccount': instance.sendAccount,
      'sendName': instance.sendName,
      'status': instance.status,
      'transDate': instance.transDate,
      'transDatetime': instance.transDatetime?.toIso8601String(),
      'transTime': instance.transTime,
      'txnum': instance.txnum,
      'type': instance.type,
      'username': instance.username,
      'vat': instance.vat,
      'feeType': instance.feeType,
      'reason': instance.reason,
      'relationNo': instance.relationNo,
      'transType': instance.transType,
    };
