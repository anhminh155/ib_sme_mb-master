import 'package:ib_sme_mb_view/network/api/api.dart';
import 'package:ib_sme_mb_view/model/model.dart';

class BannerService {
  String url = "/api/auth/getdk";
  Future<BaseResponseDataList> getListBanner() async {
    var response = await Api.httpGet('/api/bannergroup/getbanner', {});
    return BaseResponseDataList.fromJson(response);
  }
}
