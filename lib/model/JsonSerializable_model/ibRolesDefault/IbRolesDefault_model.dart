import 'package:ib_sme_mb_view/model/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'IbRolesDefault_model.g.dart';

@JsonSerializable()
class IBRolesDefaultModel {
  int? id;
  String? status;
  String? approveType;
  int? position;
  IBRolesModel? ibRoles;

  IBRolesDefaultModel(
      {this.id, this.status, this.approveType, this.position, this.ibRoles});
  factory IBRolesDefaultModel.fromJson(Map<String, dynamic> json) =>
      _$IBRolesDefaultModelFromJson(json);
  Map<String, dynamic> toJson() => _$IBRolesDefaultModelToJson(this);
}
