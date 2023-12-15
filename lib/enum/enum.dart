// ignore_for_file: constant_identifier_names

import 'package:ib_sme_mb_view/network/services/languages_service.dart';

enum TransactionFeeType {
  NNT(1),
  NCT(2);

  const TransactionFeeType(this.value);
  final int value;

  static getNameFeeType(value) {
    switch (value) {
      case '1':
        return 'Người chuyển trả';
      case '2':
        return 'Người nhận trả';
    }
  }
}

enum IndentifypapersEnum {
  CMND('CMND'),
  CCCD('CCCD'),
  HOCHIEU('HOCHIEU');

  const IndentifypapersEnum(this.value);

  final String value;
}

enum FwError {
  THANHCONG('THANHCONG'),
  KHONGTHANHCONG('KHONGTHANHCONG'),
  DLKHONGTONTAI('DLKHONGTONTAI'),
  DLDATONTAI('DLDATONTAI'),
  PASSWORDNOTFOUND('PASSWORDNOTFOUND'),
  PASSWORDFAILLIMIT('PASSWORDFAILLIMIT'),
  DUPLICATEPASSWORD('DUPLICATEPASSWORD'),
  TIMESEARCH('TIMESEARCH'),
  LOGOUT('LOGOUT'),
  XACTHUCOTP('XACTHUCOTP'),
  HANMUCKHONGHOPLE('HANMUCKHONGHOPLE'),
  DOIMATKHAU('DOIMATKHAU'),
  QUASOLUONG('QUASOLUONG');

  const FwError(this.value);
  final String value;
}

enum YesNoEnum {
  Y(1),
  N(0);

  const YesNoEnum(this.value);
  final int value;
}

enum PositionEnum {
  QUANTRI(1),
  LAPLENH(2),
  DUYETLENH(3);

  const PositionEnum(this.value);
  final int value;

  static String getName(int value, context) {
    switch (value) {
      case 1:
        return translation(context)!.adminKey;
      case 2:
        return translation(context)!.makerKey;
      case 3:
        return translation(context)!.checkerKey;
      default:
        return '';
    }
  }
}

enum CompanyTypeEnum {
  MOHINHCAP1('1'),
  MOHINHCAP2('2');

  const CompanyTypeEnum(this.value);
  final String value;
}

enum CustStatusEnum {
  CHOKICHHOAT(0),
  HOATDONG(1),
  KHOA(2),
  HUY(3);

  const CustStatusEnum(this.value);
  final int value;
}

enum VerifyTypeEnum {
  SMS(1),
  SMARTOTP(2);

  const VerifyTypeEnum(this.value);
  final int value;

  static getName(int value) {
    switch (value) {
      case 1:
        return "SMS OTP";
      case 2:
        return "Smart OTP";
      default:
        return '';
    }
  }
}

enum StatusPaymentTrans {
  TATCA(null),
  CHOXULY(0),
  THANHCONG(1),
  LOI(2),
  HUY(3);

  const StatusPaymentTrans(this.value);
  final dynamic value;

  static dynamic getStringByKey(StatusPaymentTrans key) {
    switch (key) {
      case TATCA:
        return StatusPaymentTransString.TATCA.value;
      case CHOXULY:
        return StatusPaymentTransString.CHOXULY.value;
      case THANHCONG:
        return StatusPaymentTransString.THANHCONG.value;
      case LOI:
        return StatusPaymentTransString.LOI.value;
      case HUY:
        return StatusPaymentTransString.HUY.value;
      default:
        return null;
    }
  }

  static dynamic getStringByValue(value) {
    switch (value) {
      case '0':
        return StatusPaymentTransString.CHOXULY.value;
      case '1':
        return StatusPaymentTransString.THANHCONG.value;
      case '2':
        return StatusPaymentTransString.LOI.value;
      case '3':
        return StatusPaymentTransString.HUY.value;
      default:
        return 'null';
    }
  }
}

enum StatusPaymentTransString {
  TATCA('Tất cả'),
  CHOXULY('Chờ xử lý'),
  THANHCONG('Thành công'),
  LOI('Lỗi'),
  HUY('Hủy');

  const StatusPaymentTransString(this.value);
  final String value;
}

enum ApproveTransLotElementEnum {
  CHUATHUCHIEN("0"),
  THANHCONG("1"),
  LOI("2");

  const ApproveTransLotElementEnum(this.value);
  final String value;

  static dynamic getStringByValue(value) {
    switch (value) {
      case '0':
        return StatusString.CHUATHUCHIEN.value;
      case '1':
        return StatusString.THANHCONG.value;
      case '2':
        return StatusString.LOI.value;
      default:
        return '';
    }
  }
}

enum StatusApprovetranslot {
  TATCA(null),
  CHODUYET(0),
  TUCHOI(1),
  DADUYET(2),
  THANHCONG(3),
  LOI(4),
  HOANTHANH(5),
  HUY(6);

  const StatusApprovetranslot(this.value);
  final dynamic value;
  static dynamic getStringByKey(StatusApprovetranslot key) {
    switch (key) {
      case TATCA:
        return StatusString.TATCA.value;
      case CHODUYET:
        return StatusString.CHODUYET.value;
      case TUCHOI:
        return StatusString.TUCHOI.value;
      case DADUYET:
        return StatusString.DADUYET.value;
      case HOANTHANH:
        return StatusString.HOANTHANH.value;
      case THANHCONG:
        return StatusString.THANHCONG.value;
      case LOI:
        return StatusString.LOI.value;
      case HUY:
        return StatusString.HUY.value;
      default:
        return null;
    }
  }

  static dynamic getStringByValue(value) {
    switch (value) {
      case '0':
        return StatusString.CHODUYET.value;
      case '1':
        return StatusString.TUCHOI.value;
      case '2':
        return StatusString.DADUYET.value;
      case '3':
        return StatusString.THANHCONG.value;
      case '4':
        return StatusString.LOI.value;
      case '5':
        return StatusString.HOANTHANH.value;
      case '6':
        return StatusString.HUY.value;
      default:
        return '';
    }
  }
}

enum StatusTrans {
  TATCA(null),
  CHODUYET(0),
  TUCHOI(1),
  DADUYET(2),
  HUY(3),
  THANHCONG(4),
  LOI(5);

  const StatusTrans(this.value);
  final dynamic value;

  static dynamic getStringByKey(StatusTrans key) {
    switch (key) {
      case TATCA:
        return StatusString.TATCA.value;
      case CHODUYET:
        return StatusString.CHODUYET.value;
      case TUCHOI:
        return StatusString.TUCHOI.value;
      case DADUYET:
        return StatusString.DADUYET.value;
      case HUY:
        return StatusString.HUY.value;
      case THANHCONG:
        return StatusString.THANHCONG.value;
      case LOI:
        return StatusString.LOI.value;
      default:
        return null;
    }
  }

  static dynamic getStringByValue(value) {
    switch (value) {
      case '0':
        return StatusString.CHODUYET.value;
      case '1':
        return StatusString.TUCHOI.value;
      case '2':
        return StatusString.DADUYET.value;
      case '3':
        return StatusString.HUY.value;
      case '4':
        return StatusString.THANHCONG.value;
      case '5':
        return StatusString.LOI.value;
      default:
        return 'null';
    }
  }
}

enum StatusString {
  TATCA('Tất cả'),
  CHODUYET('Chờ duyệt'),
  TUCHOI('Từ chối'),
  DADUYET('Đã duyệt'),
  HUY('Hủy'),
  THANHCONG('Thành công'),
  LOI('Lỗi'),
  HOANTHANH('Hoàn thành'),
  CHUATHUCHIEN('Chưa thực hiện'),
  KHONGTHUCHIENDUOC('Không thực hiện được');

  const StatusString(this.value);
  final String value;
}

enum RejectTransStatus {
  CHODUYET('0'),
  TUCHOI('1'),
  DADUYET('2'),
  HUY('3'),
  HOANTHANH('4'),
  LOI('5');

  const RejectTransStatus(this.value);
  final String value;

  static String getStringByValue(value) {
    switch (value) {
      case '0':
        return StatusString.CHODUYET.value;
      case '1':
        return StatusString.TUCHOI.value;
      case '2':
        return StatusString.DADUYET.value;
      case '3':
        return StatusString.HUY.value;
      case '4':
        return StatusString.HOANTHANH.value;
      case '5':
        return StatusString.LOI.value;
      default:
        return '';
    }
  }
}

enum TransType {
  ALL('ALL'),
  CORE("CORE"),
  CORETL("CORE"),
  COREDK("CORE"),
  CITAD("CITAD"),
  CITADTL("CITAD"),
  CITADDK("CITAD"),
  NAPAS("NAPAS"),
  NAPASTL("NAPAS"),
  NAPASDK("NAPAS"),
  CTBK("");

  const TransType(this.value);
  final String value;

  static String getName(TransType key) {
    switch (key) {
      case CORE:
        return FUNCDESCRIPTION.CTNB.value;
      case CORETL:
        return FUNCDESCRIPTION.CTTLNB.value;
      case COREDK:
        return FUNCDESCRIPTION.CTDKNB.value;
      case CITAD:
        return FUNCDESCRIPTION.CTLNH.value;
      case CITADTL:
        return FUNCDESCRIPTION.CTTLLNH.value;
      case CITADDK:
        return FUNCDESCRIPTION.CTDKLNH.value;
      case NAPAS:
        return FUNCDESCRIPTION.CTNP.value;
      case NAPASTL:
        return FUNCDESCRIPTION.CTTLNP.value;
      case NAPASDK:
        return FUNCDESCRIPTION.CTDKNP.value;
      case ALL:
        return 'Tất cả';
      default:
        return '';
    }
  }

  static String getNameByStringKey(String key, {int? schedules}) {
    switch (key) {
      case 'CORE':
        if (schedules != null) {
          return schedules == 0
              ? FUNCDESCRIPTION.CTTLNB.value
              : FUNCDESCRIPTION.CTDKNB.value;
        }
        return FUNCDESCRIPTION.CTNB.value;
      case 'CITAD':
        if (schedules != null) {
          return schedules == 0
              ? FUNCDESCRIPTION.CTTLLNH.value
              : FUNCDESCRIPTION.CTDKLNH.value;
        }
        return FUNCDESCRIPTION.CTLNH.value;
      case 'NAPAS':
        if (schedules != null) {
          return schedules == 0
              ? FUNCDESCRIPTION.CTTLNP.value
              : FUNCDESCRIPTION.CTDKNP.value;
        }
        return FUNCDESCRIPTION.CTNP.value;
      case 'CORETL':
        return FUNCDESCRIPTION.CTTLNB.value;
      case 'COREDK':
        return FUNCDESCRIPTION.CTDKNB.value;
      case 'NAPASDK':
        return FUNCDESCRIPTION.CTDKNP.value;
      case 'NAPASTL':
        return FUNCDESCRIPTION.CTTLNP.value;
      case 'CITADTL':
        return FUNCDESCRIPTION.CTTLLNH.value;
      case 'CITADDK':
        return FUNCDESCRIPTION.CTDKLNH.value;
      case 'ALL':
        return "Tất cả";
      default:
        return '';
    }
  }

  static dynamic getProductType(TransType? key) {
    switch (key) {
      case CORE:
        return TransProductType.CORE.value;
      case CITAD:
        return TransProductType.CITAD.value;
      case NAPAS:
        return TransProductType.NAPAS.value;
      default:
        return null;
    }
  }

  static dynamic getProductTypeByString(String value) {
    switch (value) {
      case 'CORE':
        return TransProductType.CORE.value;
      case 'CITAD':
        return TransProductType.CITAD.value;
      case 'NAPAS':
        return TransProductType.NAPAS.value;
      default:
        return null;
    }
  }

  static String getTypeCode(String key) {
    switch (key) {
      case 'CORE':
        return TypeCode.TRANSCORECODE.value;
      case 'CITAD':
        return TypeCode.TRANSCITADCODE.value;
      case 'NAPAS':
        return TypeCode.TRANSNAPASCODE.value;
      default:
        return '';
    }
  }

  static String getNameByValue(transProductType) {
    switch (transProductType) {
      case 3:
        return FUNCDESCRIPTION.CTNB.value;
      case 2:
        return FUNCDESCRIPTION.CTLNH.value;
      case 1:
        return FUNCDESCRIPTION.CTNP.value;
      default:
        return '';
    }
  }
}

enum TypeCode {
  TRANSCORECODE('TRANS_CORE_CODE'),
  MANAGERCODE('MANAGER_CODE'),
  ROLESCODE('ROLES_CODE'),
  TRANSCITADCODE('TRANS_CITAD_CODE'),
  TRANSNAPASCODE('TRANS_NAPAS_CODE'),
  PAYMENTCODE('PAYMENT_CODE'),
  DUYETGIAODICH('APPROVE_TRANS'),
  QUANLYMATRUYCAP('MANAGER_CODE'),
  QUANLYQUYENTRUYCAP('ACCESS_CODE'),
  FORGOTPASSWORDCODE('FORGOT_PASSWORD_CODE'),
  UPDATEPASSWORDCODE('UPDATE_PASSWORD_CODE'),
  LIMITSETTING("LIMIT_SETTING");

  const TypeCode(this.value);
  final String value;

  static String getNameFunc(TypeCode func) {
    switch (func) {
      case DUYETGIAODICH:
        return FUNCDESCRIPTION.DuyetGDCD.value;
      case QUANLYMATRUYCAP:
        return FUNCDESCRIPTION.QLMTC.value;
      case QUANLYQUYENTRUYCAP:
        return FUNCDESCRIPTION.QLQTC.value;
      case FORGOTPASSWORDCODE:
        return FUNCDESCRIPTION.QMK.value;
      case UPDATEPASSWORDCODE:
        return FUNCDESCRIPTION.DMK.value;
      case LIMITSETTING:
        return FUNCDESCRIPTION.CDHM.value;
      default:
        return '';
    }
  }
}

enum TransSchedulesEnum {
  DINHKY(1),
  TUONGLAI(0);

  const TransSchedulesEnum(this.value);
  final int value;
}

enum TransProductType {
  CORE(3),
  CITAD(2),
  NAPAS(1);

  const TransProductType(this.value);
  final int value;
}

enum FUNCDESCRIPTION {
  ALL("Tất cả"),
  QLMTC("Quản lý mã truy cập"),
  CapNhatMTC("Cập nhật mã truy cập"),
  ThemMTC("Thêm mã truy cập"),
  QLQTC("Quản lý quyền truy cập"),
  CapNhatQTC("Cập nhật quyền truy cập"),
  CapNhatQuyenGiaoDich("Cập nhật quyền giao dịch"),
  CapNhatQuyenTruyVan("Cập nhật quyền truy vấn"),
  CTNB("Chuyển khoản nội bộ"),
  CTLNH("Chuyển tiền liên ngân hàng"),
  CTNP("Chuyển tiền nhanh Napas 247"),
  CTBK("Chuyển tiền bảng kê"),
  CTTLNB("Chuyển khoản tương lai nội bộ"),
  CTTLLNH("Chuyển tiền tương lai liên ngân hàng"),
  CTTLNP("Chuyển tiền tương lai Napas 247"),
  CTDKNB("Chuyển khoản định kỳ nội bộ"),
  CTDKLNH("Chuyển tiền định kỳ liên ngân hàng"),
  CTDKNP("Chuyển tiền đinh kỳ Napas 247"),
  DuyetCTNB("Duyệt chuyển tiền nội bộ"),
  DuyetCTLNH("Duyệt chuyển tiền liên ngân hàng"),
  DuyetCTNP("Duyệt chuyển tiền NAPAS 247"),
  DuyetCTBK("Duyệt chuyển tiền bảng kê"),
  DuyetGDCD("Duyệt giao dịch"),
  QMK("Quên mật khẩu"),
  DMK("Đổi mật khẩu"),
  CDHM("Cài đặt hạn mức"),
  TTHDTIENDIEN("Hóa đơn tiền điện"),
  TTCDTTRASAU("Cước điện thoại trả sau"),
  TTHDTIENNUOC("Hóa đơn tiền nước"),
  TTCINTERNET("Cước Internet ADSL"),
  TTCDTCODINH("Cước điện thoại cố định"),
  QLDSLGDTT("Quản lý giao dịch thông thường"),
  QLDSLTLDK("Quản lý giao dịch tương lai định kỳ"),
  QLDSLENHTUCHOIHUY("Danh sách lệnh từ chối"),
  QLGDCHODUYET("Quản lý giao dịch chờ duyệt"),
  QLBANGKECHODUYET("Giao dịch bảng kê chờ duyệt"),
  QLTTBANGKE("Quản lý giao dịch bảng kê"),
  QLPHIGD("Báo cáo phí giao dịch");

  const FUNCDESCRIPTION(this.value);
  final String value;

  static String getFUNCDESCRIPTIONVALUE(FUNCDESCRIPTION func, context) {
    switch (func) {
      case ALL:
        return translation(context)!.allKey;
      case QLMTC:
        return translation(context)!.allKey;
      case CapNhatMTC:
        return translation(context)!.allKey;
      case ThemMTC:
        return translation(context)!.allKey;
      case QLQTC:
        return translation(context)!.allKey;
      case CapNhatQTC:
        return translation(context)!.allKey;
      case CapNhatQuyenGiaoDich:
        return translation(context)!.allKey;
      case CapNhatQuyenTruyVan:
        return translation(context)!.allKey;
      case CTNB:
        return translation(context)!.internal_transferKey;
      case CTLNH:
        return translation(context)!.external_transferKey;
      case CTNP:
        return translation(context)!.quick_transfer_247_outside_cbKey;
      case CTBK:
        return translation(context)!.bulk_transferKey;
      case CTTLNB:
        return translation(context)!.allKey;
      case CTTLLNH:
        return translation(context)!.allKey;
      case CTTLNP:
        return translation(context)!.allKey;
      case CTDKNB:
        return translation(context)!.allKey;
      case CTDKLNH:
        return translation(context)!.allKey;
      case CTDKNP:
        return translation(context)!.allKey;
      case DuyetCTNB:
        return translation(context)!.allKey;
      case DuyetCTLNH:
        return translation(context)!.allKey;
      case DuyetCTNP:
        return translation(context)!.allKey;
      case DuyetCTBK:
        return translation(context)!.allKey;
      case DuyetGDCD:
        return translation(context)!.allKey;
      case QMK:
        return translation(context)!.forgot_passwordKey;
      case DMK:
        return translation(context)!.allKey;
      case CDHM:
        return translation(context)!.allKey;
      case TTHDTIENDIEN:
        return translation(context)!.electricity_billKey;
      case TTCDTTRASAU:
        return translation(context)!.postpaid_mobile_phone_billKey;
      case TTHDTIENNUOC:
        return translation(context)!.water_billKey;
      case TTCINTERNET:
        return translation(context)!.internet_adsl_billKey;
      case TTCDTCODINH:
        return translation(context)!.landline_phone_billKey;
      case QLDSLGDTT:
        return translation(context)!.instant_transfer_managementKey;
      case QLDSLTLDK:
        return translation(context)!.future_periodic_transferKey;
      case QLDSLENHTUCHOIHUY:
        return translation(context)!.rejected_transationsKey;
      case QLGDCHODUYET:
        return translation(context)!.pending_approval_transationsKey;
      case QLBANGKECHODUYET:
        return translation(context)!.bulk_transfer_pending_approvalKey;
      case QLTTBANGKE:
        return translation(context)!.bulk_transfer_managementKey;
      case QLPHIGD:
        return translation(context)!.transaction_fee_reportKey;
      default:
        return '';
    }
  }
}

enum TRANSLOTSTATUSEUM {
  CHODUYET(0),
  TUCHOI(1),
  DADUYET(2),
  HUY(3),
  LOI(4),
  HOANTHANH(5);

  const TRANSLOTSTATUSEUM(this.value);
  final int value;
}

enum TransLotDetailStatusEnum {
  DAXOA('Đã xóa'),
  LENHHOPLE('Lệnh hợp lệ'),
  LENHKHONGHOPLE('Lệnh không hợp lệ');

  const TransLotDetailStatusEnum(this.value);
  final String value;

  static String getStatus(String value) {
    switch (value) {
      case '0':
        return TransLotDetailStatusEnum.DAXOA.value;
      case '1':
        return TransLotDetailStatusEnum.LENHHOPLE.value;
      case '2':
        return TransLotDetailStatusEnum.LENHKHONGHOPLE.value;
      default:
        return 'Lỗi';
    }
  }
}

enum SERVICE {
  CHUYENKHOAN247DENSOTAIKHOAN('1'),
  CHUYENKHOANLIENNGANHANG('2'),
  CHUYENKHOANNOIBOCB('3'),
  CHUYENKHOANTHEODANHSACH('4'),
  THANHTOANHOADONDIEN('5'),
  THANHTOANHOADONNUOC('6'),
  THANHTOANCUOCDIENTHOAICODINH('7'),
  THANHTOANCUOCDIDONGTRASAU('8'),
  THANHTOANCUOCINTERNETADSL('9'),
  GUITIETKIEMONLINE('10');

  const SERVICE(this.value);
  final String value;

  static getNameProduct(String value, context) {
    switch (value) {
      case "1":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTNP, context);

      case "2":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTLNH, context);
      case "3":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTNB, context);

      case "4":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTBK, context);
      case "5":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTHDTIENDIEN, context);

      case "6":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTHDTIENNUOC, context);
      case "7":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTCDTCODINH, context);

      case "8":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTCDTTRASAU, context);
      case "9":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTCINTERNET, context);

      case "10":
        return 'Gửi tiết kiệm online';
      default:
        return '';
    }
  }
}

enum StatusCustEnum {
  CHOKICHHOAT(0),
  HOATDONG(1),
  KHOA(2),
  HUY(3),
  CHODUYETKHOA(4),
  CHODUYETMO(5),
  CHODUYETCAPLAIMATKHAU(6);

  const StatusCustEnum(this.value);
  final int value;
}

enum SmartOtpEnum {
  KHONGHOATDONG("-1"),
  DAHUY("0"),
  DANGHOATDONG("1"),
  DAKHOA("2"),
  CHUADANGKY("3");

  const SmartOtpEnum(this.value);
  final String value;

  static String getStringByValue(String value) {
    switch (value) {
      case '-1':
        return 'không hoạt động';
      case '0':
        return 'đã hủy';
      case '1':
        return 'đang hoạt động';
      case '2':
        return 'đã khóa';
      case '3':
        return 'chưa đăng ký';
      default:
        return '';
    }
  }
}

enum ChannelIDNotification {
  BALANCE('CBWAY_Biz_Balance'),
  SOMETHING('CBWAY_Biz_Something'),
  LOADFILE('CBWAY_Biz_Loadfile');

  const ChannelIDNotification(this.value);
  final String value;
}

enum ChannelNameNotification {
  BALANCE('Thông báo biến động số dư'),
  SOMETHING('Thông báo khác từ hệ thống CBWay Biz'),
  LOADFILE('Thông báo tải file thành công');

  const ChannelNameNotification(this.value);
  final String value;
}

enum FAVORITES {
  CTNOIBO("1"),
  CTNAPAS("2"),
  CTLIENNGANHANG("3"),
  CTBANGKE("4"),
  HDTIENDIEN("5"),
  CDTTRASAU("6"),
  HDTIENNUOC("7"),
  CINTERNET("8"),
  CDTCODINH("9"),
  QLTTLENHGD("10"),
  QLTTLENHTLDK("11"),
  DSLENHTUCHOIHUY("12"),
  GDCHODUYET("13"),
  BANGKECHODUYET("14"),
  QLTTBANGKE("15"),
  QLPHIGD("16");

  const FAVORITES(this.value);
  final String value;

  // static getStringByValue(String value) {
  //   switch (value) {
  //     case "1":
  //       return FUNCDESCRIPTION.CTNB.value;
  //     case "2":
  //       return FUNCDESCRIPTION.CTNP.value;
  //     case "3":
  //       return FUNCDESCRIPTION.CTLNH.value;
  //     case "4":
  //       return FUNCDESCRIPTION.CTBK.value;
  //     case "5":
  //       return FUNCDESCRIPTION.TTHDTIENDIEN.value;
  //     case "6":
  //       return FUNCDESCRIPTION.TTCDTTRASAU.value;
  //     case "7":
  //       return FUNCDESCRIPTION.TTHDTIENNUOC.value;
  //     case "8":
  //       return FUNCDESCRIPTION.TTCINTERNET.value;
  //     case "9":
  //       return FUNCDESCRIPTION.TTCDTCODINH.value;
  //     case "10":
  //       return FUNCDESCRIPTION.QLDSLGDTT.value;
  //     case "11":
  //       return FUNCDESCRIPTION.QLDSLTLDK.value;
  //     case "12":
  //       return FUNCDESCRIPTION.QLDSLENHTUCHOIHUY.value;
  //     case "13":
  //       return FUNCDESCRIPTION.QLGDCHODUYET.value;
  //     case "14":
  //       return FUNCDESCRIPTION.QLBANGKECHODUYET.value;
  //     case "15":
  //       return FUNCDESCRIPTION.QLTTBANGKE.value;
  //     case "16":
  //       return FUNCDESCRIPTION.QLPHIGD.value;
  //     default:
  //       return '';
  //   }
  // }

  static getStringByValue(String value, context) {
    switch (value) {
      case "1":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTNB, context);
      case "2":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTNP, context);
      case "3":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTLNH, context);
      case "4":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.CTBK, context);
      case "5":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTHDTIENDIEN, context);
      case "6":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTCDTTRASAU, context);
      case "7":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTHDTIENNUOC, context);
      case "8":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTCINTERNET, context);
      case "9":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.TTCDTCODINH, context);
      case "10":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLDSLGDTT, context);
      case "11":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLDSLTLDK, context);
      case "12":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLDSLENHTUCHOIHUY, context);
      case "13":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLGDCHODUYET, context);
      case "14":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLBANGKECHODUYET, context);
      case "15":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLTTBANGKE, context);
      case "16":
        return FUNCDESCRIPTION.getFUNCDESCRIPTIONVALUE(
            FUNCDESCRIPTION.QLPHIGD, context);
      default:
        return '';
    }
  }
}

enum ActionChange {
  THEMMOI("1"),
  CAPNHAT("2"),
  MOKHOA("3"),
  KHOA("4"),
  BATTHONGBAO("5"),
  TATTHONGBAO("6"),
  BATSMS("7"),
  TATSMS("8"),
  HUY("9"),
  KICHHOAT("10");

  const ActionChange(this.value);
  final String value;

  static getNameByValue(String value) {
    switch (value) {
      case "1":
        return "Thêm mới";
      case "2":
        return "Cập nhật";
      case "3":
        return "Mở khóa";
      case "4":
        return "Khóa";
      case "5":
        return "Bật thông báo";
      case "6":
        return "Tắt thông báo";
      case "7":
        return "Bật SMS";
      case "8":
        return "Tắt SMS";
      case "9":
        return "Hủy";
      case "10":
        return "Kích hoạt";
      default:
        return '';
    }
  }
}
