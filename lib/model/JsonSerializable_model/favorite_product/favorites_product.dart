import 'package:json_annotation/json_annotation.dart';
part 'favorites_product.g.dart';

@JsonSerializable()
class FavoriteProducts {
  final int? id;
  final int? num;
  final String? product;

  const FavoriteProducts({this.id, this.num, this.product});

  factory FavoriteProducts.fromJson(Map<String, dynamic> json) =>
      _$FavoriteProductsFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteProductsToJson(this);
}
