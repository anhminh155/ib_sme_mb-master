import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/network/api/api.dart';

class SearchTransactionService {
  Future<dynamic> searchPaging(
      String url, PagesRequest page, TranSearch? transaction,
      [bool sortID = false]) async {
    Map<String, dynamic> queryParameters = {};

    queryParameters["sort"] = "createdAt,desc";
    if (sortID == true) {
      queryParameters["sort"] = "id,desc";
    }
    if (page.curentPage != 0) queryParameters["page"] = page.curentPage - 1;
    if (page.size != null) queryParameters["size"] = page.size;
    if (transaction != null) {
      queryParameters.addAll(transaction.toJson());
    }
    String urls = Api.getFullUrlWithParams(url, queryParameters);
    var response = await Api.httpGet(urls, {});
    return BasePagingResponse.fromJson(response);
  }
}
