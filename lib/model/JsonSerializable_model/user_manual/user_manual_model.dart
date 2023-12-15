import 'package:json_annotation/json_annotation.dart';

part 'user_manual_model.g.dart';

@JsonSerializable()
class UserManualModel {
  int? id;
  String? filename;
  String? name;
  int? status;
  dynamic findex;
  dynamic data;

  UserManualModel(
      {this.id, this.data, this.filename, this.findex, this.name, this.status});
  factory UserManualModel.fromJson(Map<String, dynamic> json) =>
      _$UserManualModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserManualModelToJson(this);
}
