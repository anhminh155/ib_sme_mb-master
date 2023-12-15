import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class LimitAccountService {
  Future<BaseResponse> getLimitAccount() async {
    var response = await Api.httpGet('/api/auth/max-on-mb', {});
    return BaseResponse.fromJson(response);
  }
}
