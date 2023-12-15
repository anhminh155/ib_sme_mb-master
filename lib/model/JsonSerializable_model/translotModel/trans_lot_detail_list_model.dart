import 'package:ib_sme_mb_view/model/models.dart';
import 'package:json_annotation/json_annotation.dart';
part 'trans_lot_detail_list_model.g.dart';

@JsonSerializable()
class TranslotDetailListModel {
  final int id;
  final String? amount;
  final String? fee;
  final String? sendAccount;
  final String? status;
  final String? total;
  final List<TranslotDetailModel>? transLotDetails;

  TranslotDetailListModel(this.amount, this.fee, this.sendAccount, this.status,
      this.total, this.transLotDetails, this.id);
  factory TranslotDetailListModel.fromJson(Map<String, dynamic> json) =>
      _$TranslotDetailListModelFromJson(json);
  Map<String, dynamic> toJson() => _$TranslotDetailListModelToJson(this);
}
