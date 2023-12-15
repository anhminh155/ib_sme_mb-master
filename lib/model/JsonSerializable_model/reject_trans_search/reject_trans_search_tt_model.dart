import 'package:json_annotation/json_annotation.dart';
part 'reject_trans_search_tt_model.g.dart';

@JsonSerializable()
class RejectTransSearchRequest {
  late String? sort;
  late int? page;
  late int? size;
  late String? type;
  late int? schedule; //0 tuong lai ,dinh ky 1
  late String? taiKhoanNguon;
  late String? taiKhoanThuHuong;
  late String? tenNguoiThuHuong;
  late String? nganHangThuHuong;
  late String? thoiGianLapLenhTu;
  late String? thoiGianLapLenhDen;
  late String? thoiGianDuyetLenhTu;
  late String? thoiGianDuyetLenhDen;
  late String? userLapLenh;
  late String? userDuyetLenh;
  late String? status;
  late String? paymentStatus;
  late String? maGiaoDich;
  late String? khoangTienTu;
  late String? khoangTienDen;
  RejectTransSearchRequest({
    this.taiKhoanNguon,
    this.taiKhoanThuHuong,
    this.tenNguoiThuHuong,
    this.nganHangThuHuong,
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
    this.schedule,
    this.sort,
    this.page,
    this.size,
  });
  factory RejectTransSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$RejectTransSearchRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RejectTransSearchRequestToJson(this);
}
