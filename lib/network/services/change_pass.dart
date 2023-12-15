import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class ChangePassWord {
  Future<BaseResponse> changePassSmartOTP(requestBody) async {
    var response =
        await Api.httpPost('/api/cust/updatepassword-smartotp', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> changePassSMSOTP(requestBody,
      {bool fistLogin = true}) async {
    String url = '/api/cust/updatepassword';
    if (!fistLogin) {
      url = '$url-smsotp';
    }
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> sendSmsOtp(requestBody, [bool authen = true]) async {
    String? url;
    if (!authen) {
      url = '/api/auth/send-otp';
    } else {
      url = '/api/sms/send-otp';
    }
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> verifySmsOtp(requestBody) async {
    var response = await Api.httpPost('/api/sms/verify-otp', requestBody);
    return BaseResponse.fromJson(response);
  }
}
