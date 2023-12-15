import 'package:json_annotation/json_annotation.dart';

part 'trans_search.g.dart';

@JsonSerializable()
class TranSearch {
  String? type;
  String? schedule;
  String? taiKhoanNguon;
  String? taiKhoanThuHuong;
  String? tenNguoiThuHuong;
  String? thoiGianLapLenhTu;
  String? thoiGianLapLenhDen;
  String? thoiGianDuyetLenhTu;
  String? thoiGianDuyetLenhDen;
  String? userLapLenh;
  String? userDuyetLenh;
  dynamic status;
  String? paymentStatus;
  String? maGiaoDich;
  String? khoangTienTu;
  String? khoangTienDen;
  String? nganHangThuHuong;
  String? transLot;
  String? transLotCode;

  TranSearch({
    this.type,
    this.schedule,
    this.taiKhoanNguon,
    this.taiKhoanThuHuong,
    this.tenNguoiThuHuong,
    this.thoiGianLapLenhTu,
    this.thoiGianLapLenhDen,
    this.thoiGianDuyetLenhTu,
    this.thoiGianDuyetLenhDen,
    this.userLapLenh,
    this.userDuyetLenh,
    this.status,
    this.paymentStatus,
    this.maGiaoDich,
    this.khoangTienTu,
    this.khoangTienDen,
    this.nganHangThuHuong,
    this.transLot,
    this.transLotCode,
  });
  factory TranSearch.fromJson(Map<String, dynamic> json) =>
      _$TranSearchFromJson(json);
  Map<String, dynamic> toJson() => _$TranSearchToJson(this);
}
