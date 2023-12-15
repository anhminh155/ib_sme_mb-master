import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:intl/intl.dart';

class CusService {
  String url = "/api/cust";
  Future<BasePagingResponse<Cust>> searchPaging(PagesRequest page, Cust cust,
      {String? urls}) async {
    Map<String, dynamic> queryParameters = {};
    String urlTemp = '';
    queryParameters["sort"] = "createdAt,desc";
    if (page.curentPage != 0) queryParameters["page"] = page.curentPage - 1;
    if (page.size != null) queryParameters["size"] = page.size;
    if (cust.code != null) queryParameters["code"] = cust.code;
    if (cust.tel != null) queryParameters["tel"] = cust.tel;
    if (cust.email != null) queryParameters["email"] = cust.email;
    if (cust.status != null) queryParameters["status"] = cust.status;
    if (cust.position != null) queryParameters["position"] = cust.position;
    if (urls != null) {
      urlTemp = urls;
    } else {
      urlTemp = url;
    }
    var response = await Api.httpGet(urlTemp, queryParameters);
    return BasePagingResponse<Cust>.fromJson(response);
  }

  Future<BaseResponse<dynamic>> checkLength() async {
    var response = await Api.httpGet("$url/check-length", {});
    return BaseResponse<dynamic>.fromJson(response);
  }

  Future<BaseResponse> checkDuplicate(Cust cust) async {
    var response = await Api.httpPost("$url/check-dup", cust);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> create(requestBody) async {
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse<Cust>> update(requestBody) async {
    var response = await Api.httpPut(url, requestBody);
    return BaseResponse<Cust>.fromJson(response);
  }

  Future<BaseResponse> getCustInfo() async {
    String urlApi = '$url/cust-roles';
    var response = await Api.httpGet(urlApi, {});
    return BaseResponse<Cust>.fromJson(response);
  }

  Future<BaseResponse> getCustWithCustAcc(int id) async {
    Map<String, dynamic> queryParameters = {"id": id};
    var response = await Api.httpGet('$url/detail', queryParameters);
    return BaseResponse<Cust>.fromJson(response);
  }

  Future<BaseResponse> getCodeCust(int position) async {
    Map<String, dynamic> queryParameters = {"position": position};
    var response = await Api.httpGet('$url/code', queryParameters);
    return BaseResponse<Cust>.fromJson(response);
  }

  Future<BaseResponse> updateSMSCust(requestBody) async {
    var response = await Api.httpPut('$url/update-sms', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateNotiCust(requestBody) async {
    var response = await Api.httpPut('$url/update-noti', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateStatusCustLock(requestBody) async {
    var response = await Api.httpPut('$url/update-lock', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateStatusCustUnLock(requestBody) async {
    var response = await Api.httpPut('$url/update-open-lock', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateStatusCustCancel(requestBody) async {
    var response = await Api.httpPut('$url/update-cancle', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateQuyenTruyVanCust(requestBody) async {
    var response = await Api.httpPut('$url/updatetruyvan', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateQuyenGiaoDichCust(requestBody) async {
    var response = await Api.httpPut('$url/updategiaodich', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateRoleTranCust(requestBody) async {
    var response = await Api.httpPut('$url/update-tran', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateRoleSearchCust(requestBody) async {
    var response = await Api.httpPut('$url/update-search', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BasePagingResponse<CustHis>> getListCustHis(custId,
      {String? dateFrom, String? dateTo}) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters['sort'] = 'createdAt,desc';
    queryParameters['page'] = 0;
    queryParameters['size'] = 1000;
    queryParameters['custId'] = custId;
    if (dateFrom != null && dateFrom != '') {
      queryParameters['tuNgay'] = DateFormat('MM/dd/yyyy')
          .format(DateFormat("dd/MM/yyyy").parse(dateFrom));
    }
    if (dateTo != null && dateTo != '') {
      queryParameters['denNgay'] = DateFormat('MM/dd/yyyy')
          .format(DateFormat("dd/MM/yyyy").parse(dateTo));
    }

    var response = await Api.httpGet('/api/custhis', queryParameters);

    return BasePagingResponse.fromJson(response);
  }
}
