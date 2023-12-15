import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class IBRolesDefaultService {
  Future getIBRolesDefault(int? custID, String path) async {
    Map<String, dynamic> requestParams = {};
    if (custID != null) requestParams['custId'] = custID;
    var response =
        await Api.httpGet("/api/ibrolesdefault/$path", requestParams);
    return BaseResponse.fromJson(response);
  }
}
