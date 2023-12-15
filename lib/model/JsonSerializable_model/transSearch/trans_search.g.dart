// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranSearch _$TranSearchFromJson(Map<String, dynamic> json) => TranSearch(
      type: json['type'] as String?,
      schedule: json['schedule'] as String?,
      taiKhoanNguon: json['taiKhoanNguon'] as String?,
      taiKhoanThuHuong: json['taiKhoanThuHuong'] as String?,
      tenNguoiThuHuong: json['tenNguoiThuHuong'] as String?,
      thoiGianLapLenhTu: json['thoiGianLapLenhTu'] as String?,
      thoiGianLapLenhDen: json['thoiGianLapLenhDen'] as String?,
      thoiGianDuyetLenhTu: json['thoiGianDuyetLenhTu'] as String?,
      thoiGianDuyetLenhDen: json['thoiGianDuyetLenhDen'] as String?,
      userLapLenh: json['userLapLenh'] as String?,
      userDuyetLenh: json['userDuyetLenh'] as String?,
      status: json['status'],
      paymentStatus: json['paymentStatus'] as String?,
      maGiaoDich: json['maGiaoDich'] as String?,
      khoangTienTu: json['khoangTienTu'] as String?,
      khoangTienDen: json['khoangTienDen'] as String?,
      nganHangThuHuong: json['nganHangThuHuong'] as String?,
      transLot: json['transLot'] as String?,
      transLotCode: json['transLotCode'] as String?,
    );

Map<String, dynamic> _$TranSearchToJson(TranSearch instance) =>
    <String, dynamic>{
      'type': instance.type,
      'schedule': instance.schedule,
      'taiKhoanNguon': instance.taiKhoanNguon,
      'taiKhoanThuHuong': instance.taiKhoanThuHuong,
      'tenNguoiThuHuong': instance.tenNguoiThuHuong,
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
      'nganHangThuHuong': instance.nganHangThuHuong,
      'transLot': instance.transLot,
      'transLotCode': instance.transLotCode,
    };
