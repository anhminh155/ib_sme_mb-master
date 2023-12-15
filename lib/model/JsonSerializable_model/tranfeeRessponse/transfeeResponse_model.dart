// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'transfeeResponse_model.g.dart';

@JsonSerializable()
class TransfeeResponse {
  final int? stt;
  final String fee;
  final String vat;

  TransfeeResponse({required this.stt, required this.fee, required this.vat});

  factory TransfeeResponse.fromJson(Map<String, dynamic> json) =>
      _$TransfeeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransfeeResponseToJson(this);
}
