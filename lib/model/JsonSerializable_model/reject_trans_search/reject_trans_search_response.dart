import 'package:json_annotation/json_annotation.dart';
part 'reject_trans_search_response.g.dart';

@JsonSerializable()
class RejectTransResponse {
  final String? code;
  final String? amount;
  final String? receiveName;
  final String? type;
  final int? schedules;
  RejectTransResponse(
      this.code, this.amount, this.receiveName, this.type, this.schedules);
  factory RejectTransResponse.fromJson(Map<String, dynamic> json) =>
      _$RejectTransResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RejectTransResponseToJson(this);
}
