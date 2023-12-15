import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class FeeService {
  Future<BaseResponse<FeeModel>> getFee(
      Map<String, dynamic> requestBody) async {
    var response =
        await Api.httpPost('/api/transfee/getpackagefee', requestBody);
    return BaseResponse.fromJson(response);
  }
}
