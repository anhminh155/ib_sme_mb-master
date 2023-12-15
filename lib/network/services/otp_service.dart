import 'package:ib_sme_mb_view/main.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/services/sharedPreferences_service.dart';
import 'package:ib_sme_mb_view/utils/formatDatetime.dart';
import '../api/api.dart';

class OtpService {
  Future<BaseResponse> initialization() async {
    Map<String, dynamic> queryParameters = {};
    var response =
        await Api.httpPost("/api/otp/initialization", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getKey(String masterKeyId) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters['signatureKeyId'] = masterKeyId;
    var response = await Api.httpPost("/api/otp/key/search", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> insertOrUpdateDevDevice() async {
    Map<String, dynamic> queryParameters = {};
    var response =
        await Api.httpPost("/api/otp/initialization", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> sendSmsOtp(
      {String? initializationCode, String? otpTokenId}) async {
    Map<String, dynamic> queryParameters = {};
    if (initializationCode != null) {
      queryParameters['initializationCode'] = initializationCode;
    }
    if (otpTokenId != null) {
      queryParameters['otpTokenId'] = otpTokenId;
    }
    var response = await Api.httpPost("/api/otp/send-sms-otp", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> verifiSmsOtp(
      {String? initializationCode,
      String? otpTokenId,
      required String smsOtpCode}) async {
    Map<String, dynamic> queryParameters = {};
    if (initializationCode != null) {
      queryParameters['initializationCode'] = initializationCode;
    }
    if (otpTokenId != null) {
      queryParameters['otpTokenId'] = otpTokenId;
    }
    queryParameters['smsOtpCode'] = smsOtpCode;
    var response =
        await Api.httpPost("/api/otp/verify-sms-otp", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> enroll(OtpModel model) async {
    var response = await Api.httpPost("/api/otp/enroll", model.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> disableTokenID() async {
    Map<String, dynamic> queryParameters = {};
    final currentUser =
        LoginResponse.fromJson(localStorage.getItem('currentUser'));
    queryParameters['accountId'] = currentUser.username;
    var response =
        await Api.httpPost("/api/otp/token/disable", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> changePin(OtpChangePinRequest request) async {
    var response =
        await Api.httpPost("/api/otp/token/change-pin", request.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> restorePin(OtpRestorePinRequest request) async {
    var response =
        await Api.httpPost("/api/otp/token/restore-pin", request.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> checkPassword(String password) async {
    Map<String, dynamic> request = {};
    request['password'] = password;
    var response = await Api.httpGet("/api/cust/check-password", request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> checkTokenOtp(String token) async {
    Map<String, dynamic> request = {};
    request['token'] = token;
    var response = await Api.httpGet("/api/otp/checktoken", request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getParamsOTP() async {
    var response = await Api.httpGet("/api/sysparameter/parameter-mb", null);
    return BaseResponse.fromJson(response);
  }

  static String validParamsOTP(String username){
    String errorMessage = '';
    var otpModel = getUserByName(username);
    OtpSettingModel otpSettingModel = sharedpf.getParamSettingOTP();
    if(otpModel.timeLock!= null){
      if(isLock(otpModel,otpSettingModel)){
        var dateLock = convertDatetime(otpModel, otpSettingModel);
        errorMessage = 'Mã Pin của quý khách sẽ được mở khóa lúc: ${convertDateTimeFormat(dateLock.toString())}';
      }else{
        unlockPin(username);
      }
    }
    return errorMessage;
  }

  static resetPin(String username){
    var newOtpModel = getUserByName(username).copyWith(timesEnterError: 0);
    sharedpf.addCustToListUserOTP(newOtpModel);
  }

  static unlockPin(String username){
    var newOtpModel = getUserByName(username).copyWith(timesEnterError: 0,timeLock: null);
    sharedpf.addCustToListUserOTP(newOtpModel);
  }

  static isLock(otpModel, otpSettingModel){
    DateTime dateLock = convertDatetime(otpModel, otpSettingModel);
    DateTime currentTime = DateTime.now();
    if (currentTime.difference(dateLock).inSeconds <=0) {
      return true;
    }
    return false;
  }

  static DateTime convertDatetime(InitUserOTPModel otpModel, OtpSettingModel otpSettingModel) 
  => DateTime.parse(otpModel.timeLock!).add(Duration(minutes: otpSettingModel.dateLock)).toLocal();


  static String updateEnterFalsePinOTP(String username){
    String errorMessage = '';
    var otpModel = getUserByName(username);
    OtpSettingModel otpSettingModel = sharedpf.getParamSettingOTP();
    InitUserOTPModel newOtpModel;
    if(otpModel.timesEnterError >= otpSettingModel.pinFalse-1){
      errorMessage = 'Mã pin của quý khách đã bị khóa do nhập sai quá 5 lần';
      newOtpModel = otpModel.copyWith(timeLock: DateTime.now().toLocal().toString());
    }else{
      newOtpModel = otpModel.copyWith(timesEnterError: otpModel.timesEnterError + 1);
    }
    sharedpf.addCustToListUserOTP(newOtpModel);
    return errorMessage;
  }

  static InitUserOTPModel getUserByName(String username){
    var listUser = sharedpf.getListUserOTP();
    return listUser.firstWhere((element) => element.username == username);
  }
}
