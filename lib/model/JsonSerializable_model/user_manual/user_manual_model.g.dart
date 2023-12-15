// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_manual_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserManualModel _$UserManualModelFromJson(Map<String, dynamic> json) =>
    UserManualModel(
      id: json['id'] as int?,
      data: json['data'],
      filename: json['filename'] as String?,
      findex: json['findex'],
      name: json['name'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$UserManualModelToJson(UserManualModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'name': instance.name,
      'status': instance.status,
      'findex': instance.findex,
      'data': instance.data,
    };
