// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transSchedulesDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransSchedulesDetailsModel _$TransSchedulesDetailsModelFromJson(
        Map<String, dynamic> json) =>
    TransSchedulesDetailsModel(
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      createdByCust: json['createdByCust'] == null
          ? null
          : Cust.fromJson(json['createdByCust'] as Map<String, dynamic>),
      updatedByCust: json['updatedByCust'] == null
          ? null
          : Cust.fromJson(json['updatedByCust'] as Map<String, dynamic>),
      id: json['id'] as int?,
      code: json['code'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      reqId: json['reqId'] as String?,
      resCode: json['resCode'] as String?,
      resDes: json['resDes'] as String?,
      resId: json['resId'] as String?,
      revertCode: json['revertCode'] as String?,
      revertDes: json['revertDes'] as String?,
      revertFeeCode: json['revertFeeCode'] as String?,
      revertFeeDes: json['revertFeeDes'] as String?,
      scheduledDate: json['scheduledDate'] as String?,
      transDate: json['transDate'] as String?,
      reason: json['reason'] as String?,
      transSchedule: json['transSchedule'] == null
          ? null
          : TransScheduleModel.fromJson(
              json['transSchedule'] as Map<String, dynamic>),
      txnum: json['txnum'] as String?,
      repayStatus: json['repayStatus'] as String?,
      repayOldCode: json['repayOldCode'] as String?,
    );

Map<String, dynamic> _$TransSchedulesDetailsModelToJson(
        TransSchedulesDetailsModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'createdByCust': instance.createdByCust,
      'updatedByCust': instance.updatedByCust,
      'id': instance.id,
      'code': instance.code,
      'paymentStatus': instance.paymentStatus,
      'reqId': instance.reqId,
      'resCode': instance.resCode,
      'resDes': instance.resDes,
      'resId': instance.resId,
      'revertCode': instance.revertCode,
      'revertDes': instance.revertDes,
      'revertFeeCode': instance.revertFeeCode,
      'revertFeeDes': instance.revertFeeDes,
      'scheduledDate': instance.scheduledDate,
      'transDate': instance.transDate,
      'reason': instance.reason,
      'repayStatus': instance.repayStatus,
      'repayOldCode': instance.repayOldCode,
      'transSchedule': instance.transSchedule,
      'txnum': instance.txnum,
    };
