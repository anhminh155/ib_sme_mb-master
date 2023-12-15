import 'package:flutter/cupertino.dart';
import 'package:ib_sme_mb_view/model/models.dart';

class FavoriteProductProvider extends ChangeNotifier {
  List<FavoriteProducts> items = [];

  setFavoriteProducts(List<FavoriteProducts> items) async {
    this.items = items;
    notifyListeners();
  }

  deleteFavoriteProducts() async {
    items = [];
    notifyListeners();
  }
}
