import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class ManageManifesTransactionsService {
  Future<BasePagingResponse> searchTransactions(
      PagesRequest page, StatementTransRequest request) async {
    Map<String, dynamic> requestParams = {};

    requestParams['sort'] = 'createdAt,desc';
    if (page.curentPage != 0) requestParams['page'] = page.curentPage - 1;
    if (page.size != null) requestParams["size"] = page.size;
    requestParams.addAll(request.toJson());
    String url =
        Api.getFullUrlWithParams('/api/translot/qlttbangke', requestParams);
    var response = await Api.httpGet(url, {});
    return BasePagingResponse.fromJson(response);
  }

  Future<BaseResponse> getApproveTransLotDetail(String transLotCode) async {
    var response = await Api.httpGet('/api/translot/detail/$transLotCode', {});
    return BaseResponse.fromJson(response);
  }

  Future<BasePagingResponse> getAllTransLotDetail(
      PagesRequest page, String? transLot) async {
    Map<String, dynamic> queryParameters = {};
    if (page.curentPage != 0) queryParameters['page'] = page.curentPage - 1;
    if (page.size != null) queryParameters['size'] = page.size;
    if (transLot != null) queryParameters['transLot'] = transLot;
    var response = await Api.httpGet('/api/translotdetail/mb', queryParameters);
    return BasePagingResponse.fromJson(response);
  }
}
