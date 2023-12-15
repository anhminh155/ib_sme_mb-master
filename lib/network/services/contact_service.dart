import 'package:ib_sme_mb_view/model/model.dart';

import '../api/api.dart';

class ContactInfoService {
  String url = "/api/auth/getContactInfo";
  Future<BaseResponse<ContactInfo>> getContactInfo() async {
    var response = await Api.httpGet(url, {});
    return BaseResponse<ContactInfo>.fromJson(response);
  }
}
