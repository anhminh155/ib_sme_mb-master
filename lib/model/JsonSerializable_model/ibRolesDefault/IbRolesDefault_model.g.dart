// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IbRolesDefault_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBRolesDefaultModel _$IBRolesDefaultModelFromJson(Map<String, dynamic> json) =>
    IBRolesDefaultModel(
      id: json['id'] as int?,
      status: json['status'] as String?,
      approveType: json['approveType'] as String?,
      position: json['position'] as int?,
      ibRoles: json['ibRoles'] == null
          ? null
          : IBRolesModel.fromJson(json['ibRoles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IBRolesDefaultModelToJson(
        IBRolesDefaultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'approveType': instance.approveType,
      'position': instance.position,
      'ibRoles': instance.ibRoles,
    };
