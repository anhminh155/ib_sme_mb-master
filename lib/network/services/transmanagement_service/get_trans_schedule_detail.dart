import 'package:ib_sme_mb_view/network/api/api.dart';
import '../../../model/model.dart';

class GetTransactionScheduleService {
  Future<dynamic> getTransDetail(String url, String? code) async {
    Map<String, dynamic> queryParameters = {};
    if (code != null) {
      queryParameters['code'] = code;
    }
    var response = await Api.httpGet(url, queryParameters);
    return BaseResponse.fromJson(response);
  }
}
