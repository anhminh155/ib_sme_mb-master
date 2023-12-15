import '../../../model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class CountTransSeervice {
  Future<BaseResponse<CountTrans>> getCountTrans() async {
    var response = await Api.httpGet('/api/tran/count/all', {});
    return BaseResponse<CountTrans>.fromJson(response);
  }
}
