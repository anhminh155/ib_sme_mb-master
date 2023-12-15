import 'package:ib_sme_mb_view/network/api/api.dart';
import '../../../model/model.dart';

class UpdateTransactionService {
  Future<dynamic> cancelTransSchedule(dynamic requestBody) async {
    var response =
        await Api.httpPut('/api/transschedulesdetail/cancel', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<dynamic> cancelTransScheduleMuti(dynamic requestBody) async {
    var response =
        await Api.httpPut('/api/transschedulesdetail/cancel-muti', requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<dynamic> canelTransPendingApproval(
      Map<String, dynamic> requestBody, value) async {
    String? url;
    if (value == 1) {
      url = "/api/tran/tuchoi";
    } else if (value == 2) {
      url = "/api/transschedule/tuchoi";
    }
    var response = await Api.httpPut(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<dynamic> accessTransPendingApproval(
      Map<String, dynamic> requestBody, value) async {
    String? url;
    if (value == 1) {
      url = "/api/tran/duyet";
    } else if (value == 2) {
      url = "/api/transschedule/duyet";
    }
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getCheckLimitTransDuyet(
      Map<String, dynamic> requestBody, value) async {
    String? url;
    if (value == 1) {
      url = "/api/tran/checktransduyet";
    } else if (value == 2) {
      url = "/api/transschedule/checktransduyet";
    }
    var response = await Api.httpPost(url, requestBody);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> resendTrans(requestBody) async {
    var response =
        await Api.httpPost('/api/transschedulesdetail/resend', requestBody);
    return BaseResponse.fromJson(response);
  }
}
