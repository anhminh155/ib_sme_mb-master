import 'package:ib_sme_mb_view/model/models.dart';

class LoginRequest {
  String? username;
  String? password;
  Map<String, dynamic>? device;
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'device': device,
    };
  }
}

class PagesRequest {
  int curentPage = 0;
  int? size;
  String? sort;
}

class LoginResponse {
  final String? errorCode;
  final String? errorMessage;
  final String? token;
  final String? type;
  final String? refreshToken;
  final int? id;
  final String? username;
  final String? email;
  final dynamic roles;
  final String? lastLogin;
  final String? currentLocale;
  final String? phone;
  const LoginResponse(
      {this.errorCode,
      this.errorMessage,
      this.token,
      this.type = "Bearer",
      this.refreshToken,
      this.id,
      this.username,
      this.email,
      this.roles,
      this.lastLogin,
      this.phone,
      this.currentLocale});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      token: json['token'],
      type: json['type'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: json['roles'],
      lastLogin: json['lastLogin'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'token': token,
      'type': type,
      'refreshToken': refreshToken,
      'id': id,
      'username': username,
      'email': email,
      'lastLogin': lastLogin,
      'currentLocale': currentLocale,
      'phone': phone
      // 'roles': roles,
    };
  }
}

// class RolesModel {
//   late String position;
//   late List<RolesFunction> function;

//   Map<String, dynamic> toJson() {
//     return {
//       "position": position,
//       'subfunction': function.map((e) => e.toJson()).toList()
//     };
//   }
// }

// class RolesFunction {
//   late String subfunction;

//   Map<String, dynamic> toJson() {
//     return {'subfunction': subfunction};
//   }
// }

class BaseResponse<T> {
  final String? errorCode;
  final String? errorMessage;
  final dynamic data;
  const BaseResponse({
    this.errorCode,
    this.errorMessage,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      data: json['data'],
    );
  }
}

class SumMoneyResponse {
  final String? errorCode;
  final String? errorMessage;
  final int sumSDD;
  final int sumSFD;
  final int sumSLN;
  const SumMoneyResponse({
    this.errorCode,
    this.errorMessage,
    this.sumSDD = 0,
    this.sumSFD = 0,
    this.sumSLN = 0,
  });

  factory SumMoneyResponse.fromJson(Map<String, dynamic> json) {
    return SumMoneyResponse(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      sumSDD: json['sumSDD'] ?? 0,
      sumSFD: json['sumSFD'] ?? 0,
      sumSLN: json['sumSLN'] ?? 0,
    );
  }
}

class AccountResponse {
  final int? length;
  final int? sum;
  final List<DDAcount>? list;
  const AccountResponse({
    this.length,
    this.sum,
    this.list,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      length: json['length'],
      sum: json['sum'],
      list: json['list'] != null
          ? List.castFrom(json['list'])
              .map((e) => DDAcount.fromJson(e))
              .toList()
          : null,
    );
  }
}

class DDAccountStatmentResponse {
  final int? start;
  final int? end;
  final int? ghino;
  final int? ghico;
  final List<DDAccountStatment>? list;
  const DDAccountStatmentResponse({
    this.start,
    this.end,
    this.ghino,
    this.ghico,
    this.list,
  });

  factory DDAccountStatmentResponse.fromJson(Map<String, dynamic> json) {
    return DDAccountStatmentResponse(
      start: json['start'],
      end: json['end'],
      ghino: json['ghino'],
      ghico: json['ghico'],
      list: json['list'] != null
          ? List.castFrom(json['list'])
              .map((e) => DDAccountStatment.fromJson(e))
              .toList()
          : null,
    );
  }
}

class DDAccountStatment {
  String? acctno;
  String? txnum;
  String? txdate;
  String? txtime;
  String? tltxcd;
  int? cramt;
  int? dramt;
  int? clbal;
  int? opbal;
  String? txdesc;
  String? custname;
  String? address;
  String? license;
  String? bankBenCode;
  String? bankBenName;
  String? tkNhan;
  String? maKhNhan;
  String? nameNhan;
  DDAccountStatment({
    this.acctno,
    this.txnum,
    this.txdate,
    this.txtime,
    this.tltxcd,
    this.cramt,
    this.dramt,
    this.clbal,
    this.opbal,
    this.txdesc,
    this.custname,
    this.address,
    this.license,
    this.bankBenCode,
    this.bankBenName,
    this.tkNhan,
    this.maKhNhan,
    this.nameNhan,
  });
  factory DDAccountStatment.fromJson(Map<String, dynamic> json) {
    return DDAccountStatment(
      acctno: json['acctno'],
      txnum: json['txnum'],
      txdate: json['txdate'],
      txtime: json['txtime'],
      tltxcd: json['tltxcd'],
      cramt: json['cramt'],
      dramt: json['dramt'],
      clbal: json['clbal'],
      opbal: json['opbal'],
      txdesc: json['txdesc'],
      custname: json['custname'],
      address: json['address'],
      license: json['license'],
      bankBenCode: json['bankBenCode'],
      bankBenName: json['bankBenName'],
      tkNhan: json['tkNhan'],
      maKhNhan: json['maKhNhan'],
      nameNhan: json['nameNhan'],
    );
  }
  Map<String, dynamic> toJson() => {
        'acctno': acctno,
        'txnum': txnum,
        'txdate': txdate,
        'txtime': txtime,
        'tltxcd': tltxcd,
        'cramt': cramt,
        'dramt': dramt,
        'clbal': clbal,
        'opbal': opbal,
        'txdesc': txdesc,
        'custname': custname,
        'address': address,
        'license': license,
        'bankBenCode': bankBenCode,
        'bankBenName': bankBenName,
        'tkNhan': tkNhan,
        'maKhNhan': maKhNhan,
        'nameNhan': nameNhan,
      };
}

class BaseResquestOtp<T> {
  final String? otp;
  final String? code;
  final dynamic data;
  const BaseResquestOtp({
    this.otp,
    this.code,
    this.data,
  });

  factory BaseResquestOtp.fromJson(Map<String, dynamic> json) {
    return BaseResquestOtp(
      otp: json['otp'],
      code: json['code'],
      data: json['data'],
    );
  }
}

class BaseResponseDataList {
  final String? errorCode;
  final String? errorMessage;
  final List? data;
  const BaseResponseDataList({
    this.errorCode,
    this.errorMessage,
    this.data,
  });

  factory BaseResponseDataList.fromJson(Map<String, dynamic> json) {
    return BaseResponseDataList(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      data: json['data'],
    );
  }
}

class BasePagingResponse<T> {
  final String? errorCode;
  final String? errorMessage;
  final PageResponse<T>? data;
  const BasePagingResponse({
    this.errorCode,
    this.errorMessage,
    this.data,
  });
  factory BasePagingResponse.fromJson(Map<String, dynamic> json) {
    return BasePagingResponse(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      data: (json['data'] != null)
          ? PageResponse<T>.fromJson(json['data'])
          : null,
    );
  }
}

class PageResponse<T> {
  final bool first;
  final bool last;
  final int? totalPages;
  final int? totalElements;
  final int? size;
  final int? number;
  final int? numberOfElements;
  final List? content;
  const PageResponse({
    this.totalPages,
    this.totalElements,
    this.size,
    this.number,
    this.numberOfElements,
    this.content,
    this.first = false,
    this.last = false,
  });
  factory PageResponse.fromJson(Map<String, dynamic> json) {
    return PageResponse(
      first: json['first'],
      last: json['last'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      size: json['size'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      content: json['content'],
    );
  }
}

class Auditable {
  final Cust? createdBy;
  final DateTime? createdAt;
  final Cust? updatedBy;
  final DateTime? updatedAt;
  const Auditable({
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });
  factory Auditable.fromJson(Map<String, dynamic> json) {
    return Auditable(
      createdBy: json['createdBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedBy: json['updatedBy'],
      updatedAt: (json['updatedAt'] != null)
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}

class Cust extends Auditable {
  int? id;
  String? cif;
  String? code;
  String? idno;
  String? indentitypapers;
  dynamic birthday;
  String? email;
  String? fullname;
  String? lastlogin;
  int? loginfalseNumber;
  String? password;
  String? nmemonicName;
  int? notification;
  int? position;
  int? rolesearch;
  int? roletrans;
  String? sAllDd;
  String? sAllFd;
  String? sAllLn;
  int? sms;
  int? status;
  String? tAllDd;
  String? tel;
  String? smartOtp;
  int? verifyType;
  String? approveAt;
  int? approveBy;
  String? note;
  Company? company;
  List<CustAcc>? custAcc;
  List<CustProduct>? custProduct;
  List<PasswordHi>? passwordHi;
  List<RefreshtokenIb>? refreshtokenIbs;
  List<TransLimitCust>? transLimitCust;
  List<CustHis>? custHis;
  List<Favorites>? favorites;
  RolesAcc? roles;
  Cust({
    this.id,
    this.cif,
    this.code,
    this.idno,
    this.indentitypapers,
    this.birthday,
    this.email,
    this.fullname,
    this.lastlogin,
    this.loginfalseNumber,
    this.password,
    this.nmemonicName,
    this.notification,
    this.position,
    this.rolesearch,
    this.roletrans,
    this.sAllDd,
    this.sAllFd,
    this.sAllLn,
    this.sms,
    this.status,
    this.tAllDd,
    this.tel,
    this.smartOtp,
    this.verifyType,
    this.approveAt,
    this.approveBy,
    this.note,
    this.company,
    this.custAcc,
    this.custProduct,
    this.passwordHi,
    this.refreshtokenIbs,
    this.transLimitCust,
    this.custHis,
    this.favorites,
    this.roles,
  });
  factory Cust.fromJson(Map<String, dynamic> json) {
    return Cust(
        id: json['id'],
        cif: json['cif'],
        code: json['code'],
        idno: json['idno'],
        indentitypapers: json['indentitypapers'],
        birthday: json['birthday'],
        email: json['email'],
        fullname: json['fullname'],
        lastlogin: json['lastlogin'],
        loginfalseNumber: json['loginfalseNumber'],
        password: json['password'],
        nmemonicName: json['nmemonicName'],
        notification: json['notification'],
        position: json['position'],
        rolesearch: json['rolesearch'],
        roletrans: json['roletrans'],
        sAllDd: json['sAllDd'],
        sAllFd: json['sAllFd'],
        sAllLn: json['sAllLn'],
        sms: json['sms'],
        status: json['status'],
        tAllDd: json['tAllDd'],
        tel: json['tel'],
        smartOtp: json['smartOtp'],
        verifyType: json['verifyType'],
        approveAt: json['approveAt'],
        approveBy: json['approveBy'],
        note: json['note'],
        company:
            json['company'] != null ? Company.fromJson(json['company']) : null,
        custAcc: json['custAcc'] != null
            ? List<CustAcc>.from(
                json['custAcc'].map((e) => CustAcc.fromJson(e)))
            : null,
        custProduct: json['custProduct'] != null
            ? List<CustProduct>.from(
                json['custProduct'].map((e) => CustProduct.fromJson(e)))
            : null,
        passwordHi: json['passwordHi'] != null
            ? List<PasswordHi>.from(
                json['passwordHi'].map((e) => PasswordHi.fromJson(e)))
            : null,
        refreshtokenIbs: json['refreshtokenIbs'] != null
            ? List<RefreshtokenIb>.from(
                json['refreshtokenIbs'].map((e) => RefreshtokenIb.fromJson(e)))
            : null,
        transLimitCust: json['transLimitCust'] != null
            ? List<TransLimitCust>.from(
                json['transLimitCust'].map((e) => TransLimitCust.fromJson(e)))
            : null,
        custHis: json['custHis'] != null
            ? List<CustHis>.from(
                json['custHis'].map((e) => CustHis.fromJson(e)))
            : null,
        favorites: json['favorites'] != null
            ? List<Favorites>.from(
                json['favorites'].map((e) => Favorites.fromJson(e)))
            : null,
        roles: json['roles'] != null ? RolesAcc.fromJson(json['roles']) : null);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cif': cif,
        'code': code,
        'idno': idno,
        'indentitypapers': indentitypapers,
        'birthday': birthday,
        'email': email,
        'fullname': fullname,
        'lastlogin': lastlogin,
        'loginfalseNumber': loginfalseNumber,
        'password': password,
        'nmemonicName': nmemonicName,
        'notification': notification,
        'position': position,
        'rolesearch': rolesearch,
        'roletrans': roletrans,
        'sAllDd': sAllDd,
        'sAllFd': sAllFd,
        'sAllLn': sAllLn,
        'sms': sms,
        'status': status,
        'tAllDd': tAllDd,
        'tel': tel,
        'smartOtp': smartOtp,
        'verifyType': verifyType,
        'approveAt': approveAt,
        'approveBy': approveBy,
        'note': note,
        'company': company,
        'custAcc': custAcc,
        'custProduct': custProduct,
        'passwordHi': passwordHi,
        'transLimitCust': transLimitCust,
        'refreshtokenIbs': refreshtokenIbs,
        'custHis': custHis,
        'favorites': favorites,
        'roles': roles,
      };
}

class AllAccountResponse {
  List<CustAcc>? dd;
  List<CustAcc>? fd;
  List<CustAcc>? ln;
  AllAccountResponse({
    this.dd,
    this.fd,
    this.ln,
  });
  factory AllAccountResponse.fromJson(Map<String, dynamic> json) {
    return AllAccountResponse(
      dd: json['dd'] != null
          ? List.castFrom(json['dd']).map((e) => CustAcc.fromJson(e)).toList()
          : null,
      fd: json['fd'] != null
          ? List.castFrom(json['fd']).map((e) => CustAcc.fromJson(e)).toList()
          : null,
      ln: json['ln'] != null
          ? List.castFrom(json['ln']).map((e) => CustAcc.fromJson(e)).toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() => {
        'dd': dd,
        'fd': fd,
        'ln': ln,
      };
}

class Company extends Auditable {
  final int? id;
  final String? address;
  final String? approveType;
  final String? businessCode;
  final String? businessPlaceofissue;
  final String? businesslineCode;
  final String? businesslineName;
  final String? cif;
  final String? cifStatus;
  final String? country;
  final String? fullname;
  const Company(
      {this.id,
      this.address,
      this.approveType,
      this.businessCode,
      this.businessPlaceofissue,
      this.businesslineCode,
      this.businesslineName,
      this.cif,
      this.cifStatus,
      this.country,
      this.fullname});
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      address: json['address'],
      approveType: json['approveType'],
      businessCode: json['businessCode'],
      businessPlaceofissue: json['businessPlaceofissue'],
      businesslineCode: json['businesslineCode'],
      businesslineName: json['businesslineName'],
      cif: json['cif'],
      cifStatus: json['cifStatus'],
      country: json['country'],
      fullname: json['fullname'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'approveType': approveType,
      'businessCode': businessCode,
      'businessPlaceofissue': businessPlaceofissue,
      'businesslineCode': businessCode,
      'businesslineName': businesslineName,
      'cif': cif,
      'cifStatus': cifStatus,
      'country': country,
      'fullname': fullname,
    };
  }
}

class CustAcc extends Auditable {
  final int? id;
  final String? acc;
  final String? type;
  final String? accType;
  // final Cust? cust;
  const CustAcc({
    this.id,
    this.acc,
    this.type,
    this.accType,
    // this.cust,
  });
  factory CustAcc.fromJson(Map<String, dynamic> json) {
    return CustAcc(
      id: json['id'],
      acc: json['acc'],
      type: json['type'],
      accType: json['accType'],
      // cust: json['cust'] != null ? Cust.fromJson(json['cust']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'acc': acc,
      'type': type,
      'accType': accType,
      // 'cust': cust,
    };
  }
}

class BrandCode extends Auditable {
  final String? code;
  final String? address;
  final String? fax;
  final String? location;
  final String? name;
  final String? status;
  final String? tel;
  final String? type;
  const BrandCode({
    this.code,
    this.address,
    this.fax,
    this.location,
    this.name,
    this.status,
    this.tel,
    this.type,
  });

  factory BrandCode.fromJson(Map<String, dynamic> json) {
    return BrandCode(
      code: json['code'],
      address: json['address'],
      fax: json['fax'],
      location: json['location'],
      name: json['name'],
      status: json['status'],
      tel: json['tel'],
      type: json['type'],
    );
  }
}

class CustProduct extends Auditable {
  int? id;
  String? product;
  String? custCode;
  Cust? cust;
  CustProduct({
    this.id,
    this.product,
    this.custCode,
    this.cust,
  });
  factory CustProduct.fromJson(Map<String, dynamic> json) {
    return CustProduct(
      id: json['id'],
      product: json['product'],
      custCode: json['custCode'],
      cust: json['cust'] != null ? Cust.fromJson(json['cust']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'custCode': custCode,
      // 'cust': cust,
    };
  }
}

class PasswordHi extends Auditable {
  final int? id;
  final String? password;
  final Cust? cust;
  const PasswordHi({
    this.id,
    this.password,
    this.cust,
  });
  factory PasswordHi.fromJson(Map<String, dynamic> json) {
    return PasswordHi(
      id: json['id'],
      password: json['password'],
      cust: json['cust'] != null ? Cust.fromJson(json['cust']) : null,
    );
  }
}

class TransLimitCust extends Auditable {
  final int? id;
  final int? maxdaily;
  final int? maxtrans;
  final String? product;
  final String? productName;
  final Cust? cust;
  const TransLimitCust({
    this.id,
    this.maxdaily,
    this.maxtrans,
    this.product,
    this.productName,
    this.cust,
  });
  factory TransLimitCust.fromJson(Map<String, dynamic> json) {
    return TransLimitCust(
      id: json['id'],
      maxdaily: json['maxdaily'],
      maxtrans: json['maxtrans'],
      product: json['product'],
      productName: json['productName'],
      cust: json['cust'] != null ? Cust.fromJson(json['cust']) : null,
    );
  }
}

class ContactInfo {
  final String? code;
  final String? address;
  final String? email;
  final String? fax;
  final String? hotline;
  final String? tel;

  const ContactInfo(
      {this.code, this.address, this.email, this.fax, this.hotline, this.tel});
  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      code: json['code'],
      address: json['address'],
      email: json['email'],
      fax: json['fax'],
      hotline: json['hotline'],
      tel: json['tel'],
    );
  }
}

class TermsOfUse extends Auditable {
  final int? id;
  final String? name;
  final String? content;
  final int? status;
  const TermsOfUse({this.id, this.name, this.content, this.status});

  factory TermsOfUse.formJson(Map<String, dynamic> json) {
    return TermsOfUse(
        id: json['id'] as int,
        name: json['name'],
        content: json['content'],
        status: json['status']);
  }
}

class RefreshtokenIb {
  final int? id;
  DateTime? expiryDate;
  final String? token;

  RefreshtokenIb({this.id, this.expiryDate, this.token});
  factory RefreshtokenIb.fromJson(Map<String, dynamic> json) {
    return RefreshtokenIb(
      id: json['id'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      token: json['token'],
    );
  }
}

class CustHis {
  final int? id;
  final String? createdAt;
  final String? custHis;
  final String? action;

  const CustHis({this.id, this.createdAt, this.custHis, this.action});
  factory CustHis.fromJson(Map<String, dynamic> json) {
    return CustHis(
      id: json['id'],
      createdAt: json['createdAt'],
      custHis: json['custHis'],
      action: json['action'],
    );
  }
}

class Favorites {
  final int? id;
  final Cust? cust;
  final dynamic product;
  final dynamic num;

  const Favorites({this.id, this.cust, this.product, this.num});
  factory Favorites.fromJson(Map<String, dynamic> json) {
    return Favorites(
      id: json['id'],
      cust: json['cust'],
      product: json['product'],
      num: json['num'],
    );
  }
}
