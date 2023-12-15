// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_trans_search_tt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectTransSearchRequest _$RejectTransSearchRequestFromJson(
        Map<String, dynamic> json) =>
    RejectTransSearchRequest(
      taiKhoanNguon: json['taiKhoanNguon'] as String?,
      taiKhoanThuHuong: json['taiKhoanThuHuong'] as String?,
      tenNguoiThuHuong: json['tenNguoiThuHuong'] as String?,
      nganHangThuHuong: json['nganHangThuHuong'] as String?,
      thoiGianLapLenhTu: json['thoiGianLapLenhTu'] as String?,
      thoiGianLapLenhDen: json['thoiGianLapLenhDen'] as String?,
      thoiGianDuyetLenhTu: json['thoiGianDuyetLenhTu'] as String?,
      thoiGianDuyetLenhDen: json['thoiGianDuyetLenhDen'] as String?,
      userLapLenh: json['userLapLenh'] as String?,
      userDuyetLenh: json['userDuyetLenh'] as String?,
      status: json['status'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      maGiaoDich: json['maGiaoDich'] as String?,
      khoangTienTu: json['khoangTienTu'] as String?,
      khoangTienDen: json['khoangTienDen'] as String?,
      schedule: json['schedule'] as int?,
      sort: json['sort'] as String?,
      page: json['page'] as int?,
      size: json['size'] as int?,
    )..type = json['type'] as String?;

Map<String, dynamic> _$RejectTransSearchRequestToJson(
        RejectTransSearchRequest instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'page': instance.page,
      'size': instance.size,
      'type': instance.type,
      'schedule': instance.schedule,
      'taiKhoanNguon': instance.taiKhoanNguon,
      'taiKhoanThuHuong': instance.taiKhoanThuHuong,
      'tenNguoiThuHuong': instance.tenNguoiThuHuong,
      'nganHangThuHuong': instance.nganHangThuHuong,
      'thoiGianLapLenhTu': instance.thoiGianLapLenhTu,
      'thoiGianLapLenhDen': instance.thoiGianLapLenhDen,
      'thoiGianDuyetLenhTu': instance.thoiGianDuyetLenhTu,
      'thoiGianDuyetLenhDen': instance.thoiGianDuyetLenhDen,
      'userLapLenh': instance.userLapLenh,
      'userDuyetLenh': instance.userDuyetLenh,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'maGiaoDich': instance.maGiaoDich,
      'khoangTienTu': instance.khoangTienTu,
      'khoangTienDen': instance.khoangTienDen,
    };
