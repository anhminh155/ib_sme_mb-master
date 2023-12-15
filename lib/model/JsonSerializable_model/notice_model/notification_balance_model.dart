import 'package:json_annotation/json_annotation.dart';

part 'notification_balance_model.g.dart';

@JsonSerializable()
class NotificationBalanceModel {
  String? id;
  String? title;
  String? amount;
  String? balance;
  String? createdAt;
  String? account;
  String? content;
  String? message;
  String? isRead;
  String? txnum;
  String? type;

  NotificationBalanceModel(
      {this.id,
      this.account,
      this.amount,
      this.balance,
      this.content,
      this.createdAt,
      this.isRead,
      this.message,
      this.title,
      this.txnum,
      this.type});
  factory NotificationBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationBalanceModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationBalanceModelToJson(this);
}
