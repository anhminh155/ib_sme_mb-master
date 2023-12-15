// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_trans_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatementTransRequest _$StatementTransRequestFromJson(
        Map<String, dynamic> json) =>
    StatementTransRequest(
      sendAccount: json['sendAccount'] as String?,
      status: json['status'],
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      approvedStartDate: json['approvedStartDate'] as String?,
      approvedEndDate: json['approvedEndDate'] as String?,
      sendApprovedBy: json['sendApprovedBy'] as String?,
      updatedByCust: json['updatedByCust'] as String?,
      approvedBy: json['approvedBy'] as String?,
      transLotCode: json['transLotCode'] as String?,
      startAmount: json['startAmount'] as String?,
      endAmount: json['endAmount'] as String?,
    );

Map<String, dynamic> _$StatementTransRequestToJson(
        StatementTransRequest instance) =>
    <String, dynamic>{
      'sendAccount': instance.sendAccount,
      'status': instance.status,
      'startDate': instance.startDate,
      'approvedStartDate': instance.approvedStartDate,
      'approvedEndDate': instance.approvedEndDate,
      'endDate': instance.endDate,
      'sendApprovedBy': instance.sendApprovedBy,
      'updatedByCust': instance.updatedByCust,
      'approvedBy': instance.approvedBy,
      'transLotCode': instance.transLotCode,
      'startAmount': instance.startAmount,
      'endAmount': instance.endAmount,
    };
