import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class ForgotPass {
  Future<BaseResponse> forgotPass(
      Map<String, dynamic> requestBody, bool smartOTP) async {
    String? url;
    if (smartOTP) {
      url = '/api/auth/forgotpassword-smartotp';
    } else {
      url = '/api/auth/forgotpassword-smsotp';
    }
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> checkInfoCust(
      Map<String, dynamic> requestBody, bool smartOTP) async {
    String? url;
    if (smartOTP) {
      url = '/api/auth/check-infocust';
    } else {
      url = '/api/auth/check-infocustsms';
    }
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }
}
