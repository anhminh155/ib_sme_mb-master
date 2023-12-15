// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedBy: json['updatedBy'] as String?,
      updatedAt: json['updatedAt'] as String?,
      createdByCust: json['createdByCust'] as String?,
      id: json['id'] as int?,
      bindex: json['bindex'],
      fileClob: json['fileClob'] as String?,
      fileName: json['fileName'] as String?,
      status: json['status'] as String?,
      bannerGroup: json['bannerGroup'] as String?,
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt,
      'createdByCust': instance.createdByCust,
      'id': instance.id,
      'bindex': instance.bindex,
      'fileClob': instance.fileClob,
      'fileName': instance.fileName,
      'status': instance.status,
      'bannerGroup': instance.bannerGroup,
    };
