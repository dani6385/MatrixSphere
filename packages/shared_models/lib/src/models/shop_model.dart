
library shop_model;

import 'package:shared_models/src/models/product_model.dart';
import 'package:shared_models/src/models/order_model.dart';
import 'package:json_annotation/json_annotation.dart';part 'shop_model.g.dart';

@JsonSerializable()
class Shop {
  final String id;
  final String name;
  final String address;
  final String description;
  final String ownerUid;
  final String imageUrl;
  final Map<String, Product> products; // Map productId to Product object
  final Map<String, Order> orders; // Map orderId to Order object

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.ownerUid,
    this.imageUrl = '',
    Map<String, Product>? products,
    Map<String, Order>? orders,
  })  : products = products ?? {},
        orders = orders ?? {};

  factory Shop.fromJson(String id, Map<String, dynamic> json) =>
      _$ShopFromJson(json..['id'] = id);

  Map<String, dynamic> toJson() => _$ShopToJson(this);

  Shop copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    String? ownerUid,
    String? imageUrl,
    Map<String, Product>?products,
    Map<String, Order>? orders,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      ownerUid: ownerUid ?? this.ownerUid,
      imageUrl: imageUrl ?? this.imageUrl,
      products: products ?? this.products,
      orders: orders ?? this.orders,
    );
  }
}
