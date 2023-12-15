import 'package:ib_sme_mb_view/model/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_trans_request_model.g.dart';

@JsonSerializable()
class ListTransactionRequest {
  String otp;
  String code;
  List<Transaction> data;

  ListTransactionRequest(this.otp, this.code, this.data);

  factory ListTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$ListTransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ListTransactionRequestToJson(this);
}
