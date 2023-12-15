import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/model/model.dart';

class TransLimitByCustService {
  String url = "/api/translimitcust/getbycust";
  Future<BaseResponseDataList> getTransLimitByCust(Cust cust) async {
    int? queryParameters;
    if (cust.id != null) queryParameters = cust.id;
    var response = await Api.httpPost("$url?custId=$queryParameters", null);
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> updateTransLimitCust(
      Map<String, dynamic> transLimit) async {
    var response = await Api.httpPut("/api/translimitcust", transLimit);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponseDataList> getListCust(int? position) async {
    Map<String, dynamic> requestParams = {};
    if (position != null) requestParams['position'] = position;
    var response =
        await Api.httpGet('/api/translimitcust/getcust', requestParams);
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> checkLimitUpdate(requestBody) async {
    var response =
        await Api.httpPost('/api/translimitcust/checkhanmuc', requestBody);
    return BaseResponse.fromJson(response);
  }
}
