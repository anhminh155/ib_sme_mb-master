import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class SpecialCharactersService {
  Future<dynamic> getSpecialSharacters() async {
    var response = await Api.httpGet('/api/sysparameter/get-ktdbpassword', {});
    return BaseResponse.fromJson(response);
  }
}
