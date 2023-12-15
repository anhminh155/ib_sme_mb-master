import 'package:json_annotation/json_annotation.dart';
part 'statement_transfer_search_model.g.dart';

@JsonSerializable()
class StmTransferRequest {
  final String sort;
  late int page;
  final int size;
  final String? sendAccount;
  final String? custCode;
  final String? transLotCode;
  final String? startDate;
  final String? endDate;
  final String? startAmount;
  final String? endAmount;
  late int? status;

  StmTransferRequest(
      {required this.sort,
      required this.page,
      required this.size,
      required this.status,
      required this.sendAccount,
      required this.transLotCode,
      required this.startDate,
      required this.endDate,
      required this.startAmount,
      required this.endAmount,
      required this.custCode});

  factory StmTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$StmTransferRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StmTransferRequestToJson(this);
}
