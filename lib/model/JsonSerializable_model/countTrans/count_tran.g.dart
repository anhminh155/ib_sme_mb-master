// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_tran.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountTrans _$CountTransFromJson(Map<String, dynamic> json) => CountTrans(
      pending: json['pending'],
      reject: json['reject'],
      lotPending: json['lotPending'],
    );

Map<String, dynamic> _$CountTransToJson(CountTrans instance) =>
    <String, dynamic>{
      'pending': instance.pending,
      'reject': instance.reject,
      'lotPending': instance.lotPending,
    };
