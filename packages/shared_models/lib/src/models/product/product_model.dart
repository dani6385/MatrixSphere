
library product_model;

import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';

enum ProductStatus {
  active('Aktif'),
  inactive('Tidak Aktif'),
  draft('Draft');

  final String displayName;

  const ProductStatus(this.displayName);

  factory ProductStatus.fromString(String status) {
    return ProductStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => ProductStatus.active, // Default value if not found
    );
  }
}

@JsonSerializable()
class Product {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final double sellingPrice;
  final double purchasePrice; // Harga beli
  final int stock;
  final String imageUrl;
  final String category;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int soldCount; // Jumlah produk yang terjual

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.stock,
    this.imageUrl = '',
    required this.category,
    this.status = ProductStatus.active,
    required this.createdAt,
    this.updatedAt,
    this.soldCount = 0,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      } else if (dateValue is String) {
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return Product(
      id: id,
      shopId: data['shopId'] as String? ?? '',
      name: data['name'] as String? ?? 'Unknown Product',
      description: data['description'] as String? ?? '',
      sellingPrice: (data['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (data['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      stock: (data['stock'] as int?) ?? 0,
      imageUrl: data['imageUrl'] as String? ?? '',
      category: data['category'] as String? ?? 'Uncategorized',
      status: ProductStatus.fromString(data['status'] as String? ?? 'active'),
      createdAt: parseDate(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? parseDate(data['updatedAt']) : null,
      soldCount: (data['soldCount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'name': name,
      'description': description,
      'sellingPrice': sellingPrice,
      'purchasePrice': purchasePrice,
      'stock': stock,
      'imageUrl': imageUrl,
      'category': category,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'soldCount': soldCount,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    double? sellingPrice,
    double? purchasePrice,
    int? stock,
    String? imageUrl,
    String? category,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? soldCount,
  }) {
    return Product(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      soldCount: soldCount ?? this.soldCount,
    );
  }
}
