import 'package:json_annotation/json_annotation.dart';

part 'issue_model.g.dart';

@JsonSerializable()
class IssueModel {
  int? id;
  String? answer;
  String? question;
  int? status;

  IssueModel({this.answer, this.id, this.question, this.status});

  factory IssueModel.fromJson(Map<String, dynamic> json) =>
      _$IssueModelFromJson(json);
  Map<String, dynamic> toJson() => _$IssueModelToJson(this);
}
