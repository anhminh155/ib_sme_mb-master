import 'package:ib_sme_mb_view/model/models.dart';

class BaseComponent<T> {
  dynamic listResponse = <T>[];
  T? dataResponse;
  PagesRequest page = PagesRequest();
  int size = 10;
  bool isLoading = true;
}
