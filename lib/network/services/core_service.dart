import 'package:ib_sme_mb_view/model/models.dart';
import '../api/api.dart';

class CoreService {
  String url = "/api/core";
  Future<BaseResponse<DDAcount>> getDDAcountDetail(String id) async {
    Map<String, dynamic> queryParameters = {"acc": id};
    var response =
        await Api.httpPost("$url/getddaccountdetail", queryParameters);
    return BaseResponse<DDAcount>.fromJson(response);
  }

  Future<BaseResponse<DDAccountStatmentResponse>> getDDAccountStatment(
      bodyRequest) async {
    var response = await Api.httpPost("$url/getddaccountstatment", bodyRequest);
    return BaseResponse<DDAccountStatmentResponse>.fromJson(response);
  }
}
