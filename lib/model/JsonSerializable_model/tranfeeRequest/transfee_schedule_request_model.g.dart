// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfee_schedule_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransfeeScheduleRequest _$TransfeeScheduleRequestFromJson(
        Map<String, dynamic> json) =>
    TransfeeScheduleRequest(
      amount: json['amount'] as String,
      feeType: json['feeType'] as String,
      type: json['type'] as String,
      schedules: json['schedules'] as String,
      scheduleFuture: json['scheduleFuture'] as String?,
      schedulesFrequency: json['schedulesFrequency'] as String?,
      schedulesTime: json['schedulesTime'] as int?,
      schedulesTimesFrequency: json['schedulesTimesFrequency'] as int?,
      schedulesFromDate: json['schedulesFromDate'] as String?,
      schedulesToDate: json['schedulesToDate'] as String?,
    );

Map<String, dynamic> _$TransfeeScheduleRequestToJson(
        TransfeeScheduleRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'feeType': instance.feeType,
      'type': instance.type,
      'schedules': instance.schedules,
      'scheduleFuture': instance.scheduleFuture,
      'schedulesFrequency': instance.schedulesFrequency,
      'schedulesTime': instance.schedulesTime,
      'schedulesTimesFrequency': instance.schedulesTimesFrequency,
      'schedulesFromDate': instance.schedulesFromDate,
      'schedulesToDate': instance.schedulesToDate,
    };
