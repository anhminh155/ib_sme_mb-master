import 'package:json_annotation/json_annotation.dart';

part 'fee_model.g.dart';

@JsonSerializable()
class FeeModel {
  String? fee;
  String? vat;

  FeeModel({this.fee, this.vat});
  factory FeeModel.fromJson(Map<String, dynamic> json) =>
      _$FeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeeModelToJson(this);
}
