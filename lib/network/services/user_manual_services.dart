import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class UserManualServices {
  Future<BaseResponseDataList> getListUserManualServices() async {
    var response = await Api.httpGet('/api/auth/getcustguide', {});
    return BaseResponseDataList.fromJson(response);
  }
}
