import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class RolesAccService {
  String url = "/api/utils/roles";
  Future<BaseResponse<RolesAcc>> getRoloesCompany() async {
    var response = await Api.httpGet(url, {});
    return BaseResponse<RolesAcc>.fromJson(response);
  }
}
