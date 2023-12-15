// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_chedules_Detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransLotDetailDto _$TransLotDetailDtoFromJson(Map<String, dynamic> json) =>
    TransLotDetailDto(
      id: json['id'] as int?,
      code: json['code'] as String?,
      amount: json['amount'] as String?,
      approvedDat: json['approvedDat'] as String?,
      ccy: json['ccy'] as String?,
      fee: json['fee'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
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
      transDate: json['transDate'] as String?,
      transDatetime: json['transDatetime'] as String?,
      transTime: json['transTime'] as String?,
      txnum: json['txnum'] as String?,
      type: json['type'] as String?,
      vat: json['vat'] as String?,
      content: json['content'] as String?,
      status: json['status'] as String?,
      paymentErrorMes: json['paymentErrorMes'] as String?,
    );

Map<String, dynamic> _$TransLotDetailDtoToJson(TransLotDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'amount': instance.amount,
      'approvedDat': instance.approvedDat,
      'ccy': instance.ccy,
      'fee': instance.fee,
      'paymentStatus': instance.paymentStatus,
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
      'transDate': instance.transDate,
      'transDatetime': instance.transDatetime,
      'transTime': instance.transTime,
      'txnum': instance.txnum,
      'type': instance.type,
      'vat': instance.vat,
      'content': instance.content,
      'status': instance.status,
      'paymentErrorMes': instance.paymentErrorMes,
    };
