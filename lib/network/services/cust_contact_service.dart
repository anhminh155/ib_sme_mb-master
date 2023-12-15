import 'dart:async';
import 'package:ib_sme_mb_view/model/models.dart';
import '../api/api.dart';

class CusContactService {
  Future<dynamic> searchPaging(PagesRequest page, CustContact contact) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["sort"] = "createdAt,desc";
    if (page.curentPage != 0) queryParameters["page"] = page.curentPage - 1;
    if (page.size != null) queryParameters["size"] = page.size;
    if (contact.sortname != null) {
      queryParameters["sortname"] = contact.sortname;
    }
    var response = await Api.searchRequest('/api/custcontact', queryParameters);
    return BasePagingResponse<CustContact>.fromJson(response);
  }

  Future<dynamic> searchCustContact(
      //các màn chuyển tiền cần truyền vào custID và propductType
      PagesRequest page,
      dynamic productType,
      dynamic custID) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["sort"] = "createdAt,desc";
    if (page.curentPage != 0) queryParameters["page"] = page.curentPage - 1;
    if (page.size != null) queryParameters["size"] = page.size;
    if (productType != null) {
      queryParameters["productType"] = productType;
    }
    if (custID != null) {
      queryParameters["custId"] = custID;
    }
    var response = await Api.httpGet('/api/custcontact', queryParameters);
    return BasePagingResponse<CustContact>.fromJson(response);
  }

  Future<BaseResponse> saveCustContactTrans(
      TransSaveContactRequest custContact) async {
    var response = await Api.httpPost(
        '/api/custcontact/custcontactbyproduct', custContact.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> saveCustContact(CustContact custContact) async {
    var response = await Api.httpPost('/api/custcontact', custContact.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse<dynamic>> deleteCustContact(List<int> idList) async {
    var respone =
        await Api.httpDeleteList('/api/custcontact/deleteMulti', idList);

    return BaseResponse.fromJson(respone);
  }

  Future<BaseResponse<dynamic>> updateCustContact(
      CustContact custContact) async {
    var contact = custContact.toJson();
    var respone = await Api.httpPut('/api/custcontact', contact);
    return BaseResponse.fromJson(respone);
  }
}
