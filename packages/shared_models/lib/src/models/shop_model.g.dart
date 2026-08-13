// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopModelImpl _$$ShopModelImplFromJson(Map<String, dynamic> json) =>
    _$ShopModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ShopModelImplToJson(_$ShopModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

_$ShopListModelImpl _$$ShopListModelImplFromJson(Map<String, dynamic> json) =>
    _$ShopListModelImpl(
      shops: (json['shops'] as List<dynamic>)
          .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ShopListModelImplToJson(_$ShopListModelImpl instance) =>
    <String, dynamic>{'shops': instance.shops};

_$ShopDetailModelImpl _$$ShopDetailModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShopDetailModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  website: json['website'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  openingHours: json['openingHours'] as String?,
  closingHours: json['closingHours'] as String?,
  imageUrl: json['imageUrl'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  totalReviews: (json['totalReviews'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ShopDetailModelImplToJson(
  _$ShopDetailModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'website': instance.website,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'openingHours': instance.openingHours,
  'closingHours': instance.closingHours,
  'imageUrl': instance.imageUrl,
  'rating': instance.rating,
  'totalReviews': instance.totalReviews,
};

_$ShopDetailListModelImpl _$$ShopDetailListModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShopDetailListModelImpl(
  shopDetails: (json['shopDetails'] as List<dynamic>)
      .map((e) => ShopDetailModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ShopDetailListModelImplToJson(
  _$ShopDetailListModelImpl instance,
) => <String, dynamic>{'shopDetails': instance.shopDetails};

_$ShopCategoryModelImpl _$$ShopCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShopCategoryModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$ShopCategoryModelImplToJson(
  _$ShopCategoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
};

_$ShopCategoryListModelImpl _$$ShopCategoryListModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShopCategoryListModelImpl(
  shopCategories: (json['shopCategories'] as List<dynamic>)
      .map((e) => ShopCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ShopCategoryListModelImplToJson(
  _$ShopCategoryListModelImpl instance,
) => <String, dynamic>{'shopCategories': instance.shopCategories};
