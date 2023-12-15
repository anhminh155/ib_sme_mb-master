import 'package:ib_sme_mb_view/enum/enum.dart';
import '../../model/models.dart';
import '../api/api.dart';
import 'languages_service.dart';

// ignore: camel_case_types
class Transaction_Service {
  Future<BaseResponse> createtrans(
      Transaction data, String otp, String code) async {
    TransactionRequest request = TransactionRequest(otp, code, data);
    var response =
        await Api.httpPost("/api/tran/createtrans", request.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponseDataList> createListTrans(
      List<Transaction> data, String otp, String code) async {
    ListTransactionRequest request = ListTransactionRequest(otp, code, data);
    var response = await Api.httpPost("/api/tran/createlisttrans", request);
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> getFee(TransfeeRequest request) async {
    var response = await Api.httpPost("/api/tran/getfeeandchecktrans", request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getFeeSchedule(TransfeeScheduleRequest request) async {
    var response = await Api.httpPost("/api/transschedule/getfeeandchecktrans", request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponseDataList> getListFee(List<TransfeeRequest> params) async {
    var request = params.map((e) => e.toJson()).toList();
    var response =
        await Api.httpPost("/api/tran/getfeeandchecklisttrans", request);
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> getNameByAcc(acc) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["acc"] = acc;
    var response = await Api.httpPost("/api/core/getcustomerbyddaccount", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getNameByAccNapas(
      receiveAccount, sendAccount, receiveBankCode) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["receiveAccount"] = receiveAccount;
    queryParameters["sendAccount"] = sendAccount;
    queryParameters["receiveBankCode"] = receiveBankCode;
    var response =
        await Api.httpPost("/api/napas/getreceivename", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> checkLimitTrans(CheckLimitTransRequest request) async {
    var response = await Api.httpPost("/api/tran/checktrans", request.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> checkLimitListTrans(
      List<CheckLimitTransRequest> data) async {
    var request = data.map((e) => e.toJson()).toList();
    var response = await Api.httpPost("/api/tran/checklisttrans", request);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> createtranschedule(
      TranSchedule tranSchedule, String otp, String code) async {
    TranScheduleRequest request =
        TranScheduleRequest(otp: otp, code: code, data: tranSchedule);
    var response = await Api.httpPost(
        "/api/transschedule/createtranschedule", request.toJson());
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponseDataList> getAllDDAcount() async {
    var response = await Api.httpGet("/api/custacc/tddacc-cust", {});
    return BaseResponseDataList.fromJson(response);
  }

  Future<BaseResponse> getTransCode(String transType, context) async {
    Map<String, dynamic> queryParameters = {};
    queryParameters["func"] = TransType.getTypeCode(transType);
    queryParameters["funcDescription"] =
        translation(context)!.trans_typeKey(transType);
    var response = await Api.httpPost("/api/utils", queryParameters);
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> getSumPayment() async {
    var response = await Api.httpGet('/api/custacc/sumsdd', {});
    return BaseResponse.fromJson(response);
  }
}
