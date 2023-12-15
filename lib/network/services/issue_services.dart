import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class IssueServices {
  Future<BaseResponseDataList> getListIssueServices() async {
    var response = await Api.httpGet('/api/auth/getissue', {});
    return BaseResponseDataList.fromJson(response);
  }
}
