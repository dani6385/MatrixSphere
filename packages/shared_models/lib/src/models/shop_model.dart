library shop_model;
import 'package:freezed_annotation/freezed_annotation.dart';
part 'shop_model.freezed.dart';
part 'shop_model.g.dart';
@freezed
class ShopModel with _$ShopModel {
  const factory ShopModel({
    required String id,
    required String name,
    String? description,
  }) = _ShopModel;

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);
}
@freezed
class ShopListModel with _$ShopListModel {
  const factory ShopListModel({
    required List<ShopModel> shops,
  }) = _ShopListModel;

  factory ShopListModel.fromJson(Map<String, dynamic> json) =>
      _$ShopListModelFromJson(json);
}
@freezed
class ShopDetailModel with _$ShopDetailModel {
  const factory ShopDetailModel({
    required String id,
    required String name,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? website,
    double? latitude,
    double? longitude,
    String? openingHours,
    String? closingHours,
    String? imageUrl,
    double? rating,
    int? totalReviews,
  }) = _ShopDetailModel;

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ShopDetailModelFromJson(json);
}

@freezed
class ShopDetailListModel with _$ShopDetailListModel {
  const factory ShopDetailListModel({
    required List<ShopDetailModel> shopDetails,
  }) = _ShopDetailListModel;

  factory ShopDetailListModel.fromJson(Map<String, dynamic> json) =>
      _$ShopDetailListModelFromJson(json);
}
@freezed
class ShopCategoryModel with _$ShopCategoryModel {
  const factory ShopCategoryModel({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  }) = _ShopCategoryModel;

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ShopCategoryModelFromJson(json);
}

@freezed
class ShopCategoryListModel with _$ShopCategoryListModel {
  const factory ShopCategoryListModel({
    required List<ShopCategoryModel> shopCategories,
  }) = _ShopCategoryListModel;

  factory ShopCategoryListModel.fromJson(Map<String, dynamic> json) =>
      _$ShopCategoryListModelFromJson(json);
}