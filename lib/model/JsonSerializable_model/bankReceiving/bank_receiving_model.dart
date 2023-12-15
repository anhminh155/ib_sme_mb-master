import 'package:json_annotation/json_annotation.dart';
part 'bank_receiving_model.g.dart';

@JsonSerializable()
class BankReceivingModel {
  String code;
  String name;
  String? nameEn;
  String? sortname;
  int? status;
  String? citad;
  String? isttt;
  String? napas;
  String? swiftCode;
  String? napasCode;
  String? citadCode;
  String? bankCode;

  BankReceivingModel(
      {required this.code,
      required this.name,
      this.nameEn,
      this.sortname,
      this.swiftCode,
      this.citad,
      this.napas,
      this.citadCode,
      this.napasCode,
      this.isttt,
      this.status,
      this.bankCode});

  factory BankReceivingModel.fromJson(Map<String, dynamic> json) =>
      _$BankReceivingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BankReceivingModelToJson(this);
}
