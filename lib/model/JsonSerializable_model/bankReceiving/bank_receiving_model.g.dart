// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_receiving_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankReceivingModel _$BankReceivingModelFromJson(Map<String, dynamic> json) =>
    BankReceivingModel(
      code: json['code'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      sortname: json['sortname'] as String?,
      swiftCode: json['swiftCode'] as String?,
      citad: json['citad'] as String?,
      napas: json['napas'] as String?,
      citadCode: json['citadCode'] as String?,
      napasCode: json['napasCode'] as String?,
      isttt: json['isttt'] as String?,
      status: json['status'] as int?,
      bankCode: json['bankCode'] as String?,
    );

Map<String, dynamic> _$BankReceivingModelToJson(BankReceivingModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'sortname': instance.sortname,
      'status': instance.status,
      'citad': instance.citad,
      'isttt': instance.isttt,
      'napas': instance.napas,
      'swiftCode': instance.swiftCode,
      'napasCode': instance.napasCode,
      'citadCode': instance.citadCode,
      'bankCode': instance.bankCode,
    };
