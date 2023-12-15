import 'package:json_annotation/json_annotation.dart';

part 'notification_something_model.g.dart';

@JsonSerializable()
class NotificationSomethingModel {
  String? id;
  String? title;
  String? titleEn;
  String? content;
  String? contentEn;
  String? publishedDate;
  String? finishDate;
  String? status;
  String? type;
  String? custId;
  String? isRead;
  String? isSend;
  String? image;
  String? createdAt;

  NotificationSomethingModel(
      {this.id,
      this.title,
      this.titleEn,
      this.content,
      this.contentEn,
      this.publishedDate,
      this.finishDate,
      this.status,
      this.type,
      this.custId,
      this.isRead,
      this.isSend,
      this.image,
      this.createdAt});

  factory NotificationSomethingModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSomethingModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationSomethingModelToJson(this);
}
