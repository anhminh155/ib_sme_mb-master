// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_save_contact_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransSaveContactRequest _$TransSaveContactRequestFromJson(
        Map<String, dynamic> json) =>
    TransSaveContactRequest(
      product: json['product'] as int,
      bankReceiving: json['bankReceiving'] as Map<String, dynamic>,
      receiveName: json['receiveName'] as String,
      receiveAccount: json['receiveAccount'] as String,
      sortname: json['sortname'] as String,
    );

Map<String, dynamic> _$TransSaveContactRequestToJson(
        TransSaveContactRequest instance) =>
    <String, dynamic>{
      'product': instance.product,
      'bankReceiving': instance.bankReceiving,
      'receiveName': instance.receiveName,
      'receiveAccount': instance.receiveAccount,
      'sortname': instance.sortname,
    };
