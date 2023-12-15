import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class FavoriteProductsService {
  Future<BasePagingResponse<FavoriteProducts>> getFavoriteProducts(
      PagesRequest page) async {
    Map<String, dynamic> requestParams = {};
    requestParams['sort'] = 'createdAt,desc';
    if (page.curentPage != 0) requestParams['page'] = page.curentPage - 1;
    if (page.size != null) requestParams['size'] = page.size;

    var response = await Api.httpGet('/api/favorites', requestParams);
    return BasePagingResponse<FavoriteProducts>.fromJson(response);
  }
}
