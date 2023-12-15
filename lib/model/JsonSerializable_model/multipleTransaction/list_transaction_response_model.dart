import 'package:ib_sme_mb_view/model/models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'list_transaction_response_model.g.dart';

@JsonSerializable()
class ListTransactionResponse {
  final String errorCode;
  final String errorMessage;
  final TransactionResponse data;

  ListTransactionResponse(this.errorCode, this.errorMessage, this.data);

  factory ListTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ListTransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListTransactionResponseToJson(this);
}
