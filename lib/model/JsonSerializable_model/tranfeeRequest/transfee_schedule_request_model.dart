// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
part 'transfee_schedule_request_model.g.dart';

@JsonSerializable()
class TransfeeScheduleRequest {
  final String amount;
  final String feeType;
  final String type;
  final String schedules;
  final String? scheduleFuture;
  final String? schedulesFrequency;
  final int? schedulesTime;
  final int? schedulesTimesFrequency;
  final String? schedulesFromDate;
  final String? schedulesToDate;

  factory TransfeeScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$TransfeeScheduleRequestFromJson(json);

  TransfeeScheduleRequest({
    required this.amount,
    required this.feeType,
    required this.type,
    required this.schedules,
    this.scheduleFuture,
    this.schedulesFrequency,
    this.schedulesTime,
    this.schedulesTimesFrequency,
    this.schedulesFromDate,
    this.schedulesToDate,
  });
  Map<String, dynamic> toJson() => _$TransfeeScheduleRequestToJson(this);
}
