import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/model/model.dart';

class TermOfUseService {
  String url = "/api/auth/getdk";
  Future<BaseResponseDataList> getTermsOfUse() async {
    var response = await Api.httpGet(url, {});
    return BaseResponseDataList.fromJson(response);
  }
}
