import 'package:json_annotation/json_annotation.dart';
part 'trans_lot_detail_model.g.dart';

@JsonSerializable()
class TranslotDetailModel {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? amount;
  final String? ccy;
  final String? fee;
  final String? vat;
  final String? code;
  final String? paymentStatus;
  final String? receiveAccount;
  final String? receiveBank;
  final String? receiveName;
  final String? type;
  final String? content;
  final String? status;

  TranslotDetailModel(
    this.id,
    this.amount,
    this.ccy,
    this.fee,
    this.paymentStatus,
    this.receiveAccount,
    this.receiveBank,
    this.receiveName,
    this.type,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.vat,
  );
  factory TranslotDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TranslotDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$TranslotDetailModelToJson(this);
}
