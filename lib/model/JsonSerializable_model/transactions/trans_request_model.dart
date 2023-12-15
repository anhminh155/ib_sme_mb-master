import 'package:ib_sme_mb_view/model/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trans_request_model.g.dart';

@JsonSerializable()
class TransactionRequest {
  String otp;
  String code;
  Transaction data;

  TransactionRequest(this.otp, this.code, this.data);

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionRequestToJson(this);
}
