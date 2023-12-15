import '../../model/model.dart';
import '../api/api.dart';

class BankReceiveService {
  Future<BaseResponseDataList> getBankReceiving(context) async {
    var response = await Api.httpGet("/api/custcontact/getDsBank", {});
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponseDataList> getBankReceivingByProduct(
      dynamic product) async {
    Map<String, dynamic> queryParameters = {};
    if (product != null) {
      queryParameters['product'] = product;
    }
    var response =
        await Api.httpGet('/api/bankreceiving/getbankbyprod', queryParameters);
    return BaseResponseDataList.fromJson(response);
  }
}
