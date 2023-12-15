// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transSchedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransScheduleModel _$TransScheduleModelFromJson(Map<String, dynamic> json) =>
    TransScheduleModel(
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
      balance: json['balance'] as String?,
      approvedBy: json['approvedBy'] == null
          ? null
          : Cust.fromJson(json['approvedBy'] as Map<String, dynamic>),
      approvedDate: json['approvedDate'] as String?,
      branch: json['branch'] as String?,
      ccy: json['ccy'] as String?,
      content: json['content'] as String?,
      custId: json['custId'],
      fee: json['fee'] as String?,
      receiveAccount: json['receiveAccount'] as String?,
      receiveBank: json['receiveBank'] as String?,
      receiveName: json['receiveName'] as String?,
      sendAccount: json['sendAccount'] as String?,
      sendName: json['sendName'] as String?,
      status: json['status'] as String?,
      transDate: json['transDate'] as String?,
      transDatetime: json['transDatetime'] as String?,
      transTime: json['transTime'] as String?,
      txnum: json['txnum'] as String?,
      type: json['type'] as String?,
      username: json['username'] as String?,
      vat: json['vat'] as String?,
      schedules: json['schedules'],
      schedulesFromDate: json['schedulesFromDate'] as String?,
      schedulesToDate: json['schedulesToDate'] as String?,
      schedulesFrequency: json['schedulesFrequency'],
      schedulesTimes: json['schedulesTimes'],
      feeType: json['feeType'] as String?,
      reason: json['reason'] as String?,
    )
      ..receiveBankCode = json['receiveBankCode'] as String?
      ..schedulesFuture = json['schedulesFuture'] as String?;

Map<String, dynamic> _$TransScheduleModelToJson(TransScheduleModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'createdByCust': instance.createdByCust,
      'updatedByCust': instance.updatedByCust,
      'code': instance.code,
      'amount': instance.amount,
      'approvedBy': instance.approvedBy,
      'approvedDate': instance.approvedDate,
      'balance': instance.balance,
      'branch': instance.branch,
      'ccy': instance.ccy,
      'content': instance.content,
      'custId': instance.custId,
      'fee': instance.fee,
      'feeType': instance.feeType,
      'receiveBankCode': instance.receiveBankCode,
      'receiveAccount': instance.receiveAccount,
      'receiveBank': instance.receiveBank,
      'receiveName': instance.receiveName,
      'sendAccount': instance.sendAccount,
      'sendName': instance.sendName,
      'status': instance.status,
      'transDate': instance.transDate,
      'transDatetime': instance.transDatetime,
      'transTime': instance.transTime,
      'txnum': instance.txnum,
      'type': instance.type,
      'username': instance.username,
      'vat': instance.vat,
      'schedules': instance.schedules,
      'schedulesFromDate': instance.schedulesFromDate,
      'schedulesToDate': instance.schedulesToDate,
      'schedulesFrequency': instance.schedulesFrequency,
      'schedulesTimes': instance.schedulesTimes,
      'reason': instance.reason,
      'schedulesFuture': instance.schedulesFuture,
    };
