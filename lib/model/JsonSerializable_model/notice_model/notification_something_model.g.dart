// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_something_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSomethingModel _$NotificationSomethingModelFromJson(
        Map<String, dynamic> json) =>
    NotificationSomethingModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      titleEn: json['titleEn'] as String?,
      content: json['content'] as String?,
      contentEn: json['contentEn'] as String?,
      publishedDate: json['publishedDate'] as String?,
      finishDate: json['finishDate'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      custId: json['custId'] as String?,
      isRead: json['isRead'] as String?,
      isSend: json['isSend'] as String?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$NotificationSomethingModelToJson(
        NotificationSomethingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleEn': instance.titleEn,
      'content': instance.content,
      'contentEn': instance.contentEn,
      'publishedDate': instance.publishedDate,
      'finishDate': instance.finishDate,
      'status': instance.status,
      'type': instance.type,
      'custId': instance.custId,
      'isRead': instance.isRead,
      'isSend': instance.isSend,
      'image': instance.image,
      'createdAt': instance.createdAt,
    };
