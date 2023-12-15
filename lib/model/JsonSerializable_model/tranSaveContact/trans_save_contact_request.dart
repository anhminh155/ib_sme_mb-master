import 'package:json_annotation/json_annotation.dart';

part 'trans_save_contact_request.g.dart';

@JsonSerializable()
class TransSaveContactRequest {
  final int product;
  final Map<String, dynamic> bankReceiving;
  final String receiveName;
  final String receiveAccount;
  late final String sortname;

  TransSaveContactRequest(
      {required this.product,
      required this.bankReceiving,
      required this.receiveName,
      required this.receiveAccount,
      required this.sortname});

  factory TransSaveContactRequest.fromJson(Map<String, dynamic> json) =>
      _$TransSaveContactRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TransSaveContactRequestToJson(this);
}
