import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/model/model.dart';

class CustAccService {
  String url = "/api/custacc";
  Future<BasePagingResponse<CustAcc>> searchPaging(
      PagesRequest page, CustAcc custAcc) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["sort"] = "createdAt,desc";
    if (page.curentPage != 0) queryParameters["page"] = page.curentPage - 1;
    if (page.size != null) queryParameters["size"] = page.size;
    var response = await Api.httpGet(url, queryParameters);
    return BasePagingResponse<CustAcc>.fromJson(response);
  }

  Future<BaseResponse<CustAcc>> create(CustAcc custAcc) async {
    var response = await Api.httpPost(url, custAcc);
    return BaseResponse<CustAcc>.fromJson(response);
  }

  Future<BaseResponse<CustAcc>> update(CustAcc custAcc) async {
    var response = await Api.httpPut(url, custAcc);
    return BaseResponse<CustAcc>.fromJson(response);
  }

  Future<BaseResponse<AllAccountResponse>> getCustAccByCustId(int id) async {
    Map<String, dynamic> queryParameters = {"id": id};
    var response = await Api.httpGet("$url/acc", queryParameters);
    return BaseResponse<AllAccountResponse>.fromJson(response);
  }

  Future<BaseResponseDataList> getCustTDDByCustId(int id) async {
    Map<String, dynamic> queryParameters = {"id": id};
    var response = await Api.httpGet("$url/tdd", queryParameters);
    return BaseResponseDataList.fromJson(response);
  }

  Future<SumMoneyResponse> getAllMoneys() async {
    var response = await Api.httpGet("$url/all-moneys", {});
    return SumMoneyResponse.fromJson(response);
  }

  Future<BaseResponse> getDDAccCust() async {
    var response = await Api.httpGet("$url/ddacc-cust", {});
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getFDAccCust() async {
    var response = await Api.httpGet("$url/fdacc-cust", {});
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getLNAccCust() async {
    var response = await Api.httpGet("$url/lnacc-cust", {});
    return BaseResponse.fromJson(response);
  }
}
