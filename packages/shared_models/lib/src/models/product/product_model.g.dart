// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: json['id'] as String,
  shopId: json['shopId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  sellingPrice: (json['sellingPrice'] as num).toDouble(),
  purchasePrice: (json['purchasePrice'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
  imageUrl: json['imageUrl'] as String? ?? '',
  category: json['category'] as String,
  status:
      $enumDecodeNullable(_$ProductStatusEnumMap, json['status']) ??
      ProductStatus.active,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  soldCount: (json['soldCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'shopId': instance.shopId,
  'name': instance.name,
  'description': instance.description,
  'sellingPrice': instance.sellingPrice,
  'purchasePrice': instance.purchasePrice,
  'stock': instance.stock,
  'imageUrl': instance.imageUrl,
  'category': instance.category,
  'status': _$ProductStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'soldCount': instance.soldCount,
};

const _$ProductStatusEnumMap = {
  ProductStatus.active: 'active',
  ProductStatus.inactive: 'inactive',
  ProductStatus.draft: 'draft',
};
