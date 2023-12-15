import 'package:json_annotation/json_annotation.dart';
part 'statement_tranfer_detail_model.g.dart';

@JsonSerializable()
class StmTransferDetailRequest {
  final String sort;
  final int page;
  final int size;
  final String? transLot;

  StmTransferDetailRequest(
      {required this.sort,
      required this.page,
      required this.size,
      required this.transLot});

  factory StmTransferDetailRequest.fromJson(Map<String, dynamic> json) =>
      _$StmTransferDetailRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StmTransferDetailRequestToJson(this);
}
