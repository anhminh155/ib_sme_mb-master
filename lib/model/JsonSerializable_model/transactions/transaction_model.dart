import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class Transaction {
  String? transType;
  String amount;
  String content;
  String fee;
  String vat;
  String sendAccount;
  String receiveAccount;
  String receiveName;
  String type;
  int feeType;
  String receiveBank;
  String receiveBankCode;

  Transaction(
      {required this.transType,
      required this.amount,
      required this.content,
      required this.fee,
      required this.vat,
      required this.sendAccount,
      required this.receiveAccount,
      required this.receiveName,
      required this.type,
      required this.feeType,
      required this.receiveBank,
      required this.receiveBankCode});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
