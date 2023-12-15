import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class NotificationServices {
  String url = '/api/notification';
  Future<BaseResponseDataList> getListNotificationBlances(
      PagesRequest page) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters['sort'] = 'createdAt,desc';
    if (page.curentPage != 0) queryParameters['page'] = page.curentPage - 1;
    if (page.size != null) queryParameters['size'] = page.size;

    var response =
        await Api.httpGet('$url/balance-fluctuation', queryParameters);
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> readNotification(String? code) async {
    Map<String, dynamic> queryParams = {};
    if (code != null) queryParams['id'] = code;
    var response =
        await Api.httpGet('$url/balance-fluctuation/read', queryParams);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponseDataList> getListNotificationSomething(
      PagesRequest page) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters['sort'] = 'createdAt,desc';
    if (page.curentPage != 0) queryParameters['page'] = page.curentPage - 1;
    if (page.size != null) queryParameters['size'] = page.size;

    var response = await Api.httpGet(url, queryParameters);
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> readNotificationSomething(
      String? code, String? type) async {
    Map<String, dynamic> queryParams = {};
    if (code != null) queryParams['id'] = code;
    if (type != null) queryParams['type'] = type;
    var response = await Api.httpGet('$url/read', queryParams);
    return BaseResponse.fromJson(response);
  }
}
