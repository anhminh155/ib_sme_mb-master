// ignore_for_file: file_names

import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';

checkCompanyType(RolesAcc rolesAcc) {
  int companyType = 0;
  if (rolesAcc.type == CompanyTypeEnum.MOHINHCAP1.value) {
    companyType = 1;
  } else if (rolesAcc.type == CompanyTypeEnum.MOHINHCAP2.value) {
    companyType = 2;
  }
  return companyType;
}

bool checkRoles(dynamic product, RolesAcc? roles) {
  if (roles?.position == PositionEnum.DUYETLENH.value) {
    return false;
  }
  if (roles?.position == PositionEnum.QUANTRI.value &&
      roles?.type == CompanyTypeEnum.MOHINHCAP1.value) {
    if (roles?.function != null) {
      var chk = roles?.function!.where((item) => product == item.subFunction);
      if (chk != null && chk.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
  if (roles?.function != null &&
      roles?.position == PositionEnum.LAPLENH.value) {
    var chk = roles?.function!.where((item) => product == item.subFunction);
    if (chk != null && chk.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool checkTran(RolesAcc? roles) {
  if (roles?.tran == YesNoEnum.Y.value) {
    if (roles?.position == PositionEnum.DUYETLENH.value) {
      return false;
    }
    if (roles?.position == PositionEnum.QUANTRI.value &&
        roles?.type == CompanyTypeEnum.MOHINHCAP1.value) {
      if (roles?.function != null) {
        var chk = roles?.function!.where((item) =>
            1 <= int.parse(item.subFunction!) &&
            4 >= int.parse(item.subFunction!));
        if (chk != null && chk.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }
    }
    if (roles?.function != null &&
        roles?.position == PositionEnum.LAPLENH.value) {
      var chk = roles?.function!.where((item) =>
          1 <= int.parse(item.subFunction!) &&
          4 >= int.parse(item.subFunction!));
      if (chk != null && chk.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }
  return false;
}

bool checkPay(RolesAcc? roles) {
  if (roles?.tran == YesNoEnum.Y.value) {
    if (roles?.position == PositionEnum.DUYETLENH.value) {
      return false;
    }
    if (roles?.position == PositionEnum.QUANTRI.value &&
        roles?.type == CompanyTypeEnum.MOHINHCAP1.value) {
      if (roles?.function != null) {
        var chk = roles?.function!.where((item) =>
            5 <= int.parse(item.subFunction!) &&
            9 >= int.parse(item.subFunction!));
        if (chk != null && chk.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }
    }
    if (roles?.function != null &&
        roles?.position == PositionEnum.LAPLENH.value) {
      var chk = roles?.function!.where((item) =>
          5 <= int.parse(item.subFunction!) &&
          9 >= int.parse(item.subFunction!));
      if (chk != null && chk.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }
  return false;
}
