import '../../model/model.dart';
import '../api/api.dart';

class LocationsService {
  Future<BaseResponseDataList> getAllLocation() async {
    var response = await Api.httpGet('/api/auth/getAllBranch', {});
    return BaseResponseDataList.fromJson(response);
  }
}
