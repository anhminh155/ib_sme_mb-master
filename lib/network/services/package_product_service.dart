import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class PackageProductService {
  Future<BaseResponseDataList> getPackageProduct() async {
    var response = await Api.httpGet('/api/packagefee/getproduct', {});
    return BaseResponseDataList.fromJson(response);
  }
}
