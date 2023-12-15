// ignore_for_file: file_names
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transSchedulesDetail.g.dart';

@JsonSerializable()
class TransSchedulesDetailsModel {
  String? createdAt;
  String? updatedAt;
  Cust? createdByCust;
  Cust? updatedByCust;
  int? id;
  String? code;
  String? paymentStatus;
  String? reqId;
  String? resCode;
  String? resDes;
  String? resId;
  String? revertCode;
  String? revertDes;
  String? revertFeeCode;
  String? revertFeeDes;
  String? scheduledDate;
  String? transDate;
  String? reason;
  String? repayStatus;
  String? repayOldCode;
  TransScheduleModel? transSchedule;
  String? txnum;

  TransSchedulesDetailsModel(
      {this.createdAt,
      this.updatedAt,
      this.createdByCust,
      this.updatedByCust,
      this.id,
      this.code,
      this.paymentStatus,
      this.reqId,
      this.resCode,
      this.resDes,
      this.resId,
      this.revertCode,
      this.revertDes,
      this.revertFeeCode,
      this.revertFeeDes,
      this.scheduledDate,
      this.transDate,
      this.reason,
      this.transSchedule,
      this.txnum,
      this.repayStatus,
      this.repayOldCode});
  factory TransSchedulesDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$TransSchedulesDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransSchedulesDetailsModelToJson(this);
}
