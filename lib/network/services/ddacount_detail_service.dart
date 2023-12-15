import 'package:ib_sme_mb_view/model/dd_account_model.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class DDACountDetailService {
  Future<BaseResponse<DDAcount>> getDDAcountDetail(
      Map<String, dynamic> requestBody) async {
    var response =
        await Api.httpPost('/api/core/getddaccountdetail', requestBody);
    return BaseResponse<DDAcount>.fromJson(response);
  }
}
