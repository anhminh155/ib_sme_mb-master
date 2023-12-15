import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:provider/provider.dart';

import '../../model/model.dart';
import '../../provider/providers.dart';
import '../api/api.dart';

class GetCodeGenOTP {
  Future<dynamic> getCodeGenOTP(TypeCode func, dynamic code) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["func"] = func.value;
    queryParameters["funcDescription"] = TypeCode.getNameFunc(func);
    queryParameters["code"] = code;
    var response = await Api.httpPost("/api/utils", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<dynamic> getCodeGentOTPBiometric(String code, context) async {
    var register = Provider.of<OtpProvider>(context, listen: false).isRegister;
    if (register) {
      Map<String, dynamic> queryParameters = {};
      queryParameters["code"] = code;
      var response = await Api.httpPost("/api/utils/gen-code", queryParameters);
      return BaseResponse.fromJson(response);
    }
    return null;
  }

  Future<dynamic> verifyOTPBiometrics(dynamic requestBody) async {
    var response = await Api.httpPost("/api/utils/verify-sth", requestBody);
    return BaseResponse.fromJson(response);
  }
}
