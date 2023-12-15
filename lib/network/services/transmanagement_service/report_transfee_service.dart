import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'download_file_service.dart';

class ReportTransfeeService {
  Future<void> downloadFile(BuildContext context) async {
    await saveFileFromAPI(context,
        url: '/api/tran/exportfee', fileName: 'BCPDV', requestBody: {});
  }

  Future<BaseResponse> searchReportTransfee(
      ReportTransfeeRequest request) async {
    var response = await Api.httpGet('/api/tran/searchfee', request.toJson());
    return BaseResponse.fromJson(response);
  }
}
