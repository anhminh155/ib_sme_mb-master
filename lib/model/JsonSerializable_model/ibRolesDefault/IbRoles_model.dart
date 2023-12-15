import 'package:json_annotation/json_annotation.dart';

part 'IbRoles_model.g.dart';

@JsonSerializable()
class IBRolesModel {
  String? code;
  String? name;
  String? status;

  IBRolesModel({this.code, this.name, this.status});
  factory IBRolesModel.fromJson(Map<String, dynamic> json) =>
      _$IBRolesModelFromJson(json);
  Map<String, dynamic> toJson() => _$IBRolesModelToJson(this);
}
