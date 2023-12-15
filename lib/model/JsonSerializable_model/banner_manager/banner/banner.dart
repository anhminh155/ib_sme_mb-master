import 'package:json_annotation/json_annotation.dart';
part 'banner.g.dart';

@JsonSerializable()
class BannerModel {
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  String? createdByCust;
  int? id;
  dynamic bindex;
  String? fileClob;
  String? fileName;
  String? status;
  String? bannerGroup;

  BannerModel({
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.createdByCust,
    this.id,
    this.bindex,
    this.fileClob,
    this.fileName,
    this.status,
    this.bannerGroup,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
