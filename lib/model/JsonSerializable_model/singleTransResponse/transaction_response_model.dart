import 'package:json_annotation/json_annotation.dart';
part 'transaction_response_model.g.dart';

@JsonSerializable()
class TransactionResponse {
  final String createdAt;
  final String code;
  final String amount;
  final String content;
  final String fee;
  final String sendAccount;
  final String? receiveBankCode;
  final String receiveAccount;
  final String receiveBank;
  final String receiveName;
  final int custId;
  final String type;
  final String status;
  final String feeType; //1 nguoi chuyen tra ,2 nguoi nhan tra

  TransactionResponse(
      this.amount,
      this.content,
      this.fee,
      this.receiveBankCode,
      this.sendAccount,
      this.receiveAccount,
      this.receiveBank,
      this.receiveName,
      this.custId,
      this.type,
      this.feeType,
      this.createdAt,
      this.code,
      this.status);

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
