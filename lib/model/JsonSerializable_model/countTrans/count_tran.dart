import 'package:json_annotation/json_annotation.dart';

part 'count_tran.g.dart';

@JsonSerializable()
class CountTrans {
  dynamic pending;
  dynamic reject;
  dynamic lotPending;

  CountTrans({this.pending, this.reject, this.lotPending});

  factory CountTrans.fromJson(Map<String, dynamic> json) =>
      _$CountTransFromJson(json);
  Map<String, dynamic> toJson() => _$CountTransToJson(this);
}
