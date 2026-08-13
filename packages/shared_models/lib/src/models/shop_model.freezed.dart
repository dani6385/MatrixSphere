// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) {
  return _ShopModel.fromJson(json);
}

/// @nodoc
mixin _$ShopModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ShopModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopModelCopyWith<ShopModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopModelCopyWith<$Res> {
  factory $ShopModelCopyWith(ShopModel value, $Res Function(ShopModel) then) =
      _$ShopModelCopyWithImpl<$Res, ShopModel>;
  @useResult
  $Res call({String id, String name, String? description});
}

/// @nodoc
class _$ShopModelCopyWithImpl<$Res, $Val extends ShopModel>
    implements $ShopModelCopyWith<$Res> {
  _$ShopModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopModelImplCopyWith<$Res>
    implements $ShopModelCopyWith<$Res> {
  factory _$$ShopModelImplCopyWith(
    _$ShopModelImpl value,
    $Res Function(_$ShopModelImpl) then,
  ) = __$$ShopModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? description});
}

/// @nodoc
class __$$ShopModelImplCopyWithImpl<$Res>
    extends _$ShopModelCopyWithImpl<$Res, _$ShopModelImpl>
    implements _$$ShopModelImplCopyWith<$Res> {
  __$$ShopModelImplCopyWithImpl(
    _$ShopModelImpl _value,
    $Res Function(_$ShopModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _$ShopModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopModelImpl implements _ShopModel {
  const _$ShopModelImpl({
    required this.id,
    required this.name,
    this.description,
  });

  factory _$ShopModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'ShopModel(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  /// Create a copy of ShopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopModelImplCopyWith<_$ShopModelImpl> get copyWith =>
      __$$ShopModelImplCopyWithImpl<_$ShopModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopModelImplToJson(this);
  }
}

abstract class _ShopModel implements ShopModel {
  const factory _ShopModel({
    required final String id,
    required final String name,
    final String? description,
  }) = _$ShopModelImpl;

  factory _ShopModel.fromJson(Map<String, dynamic> json) =
      _$ShopModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of ShopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopModelImplCopyWith<_$ShopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopListModel _$ShopListModelFromJson(Map<String, dynamic> json) {
  return _ShopListModel.fromJson(json);
}

/// @nodoc
mixin _$ShopListModel {
  List<ShopModel> get shops => throw _privateConstructorUsedError;

  /// Serializes this ShopListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopListModelCopyWith<ShopListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopListModelCopyWith<$Res> {
  factory $ShopListModelCopyWith(
    ShopListModel value,
    $Res Function(ShopListModel) then,
  ) = _$ShopListModelCopyWithImpl<$Res, ShopListModel>;
  @useResult
  $Res call({List<ShopModel> shops});
}

/// @nodoc
class _$ShopListModelCopyWithImpl<$Res, $Val extends ShopListModel>
    implements $ShopListModelCopyWith<$Res> {
  _$ShopListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shops = null}) {
    return _then(
      _value.copyWith(
            shops: null == shops
                ? _value.shops
                : shops // ignore: cast_nullable_to_non_nullable
                      as List<ShopModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopListModelImplCopyWith<$Res>
    implements $ShopListModelCopyWith<$Res> {
  factory _$$ShopListModelImplCopyWith(
    _$ShopListModelImpl value,
    $Res Function(_$ShopListModelImpl) then,
  ) = __$$ShopListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ShopModel> shops});
}

/// @nodoc
class __$$ShopListModelImplCopyWithImpl<$Res>
    extends _$ShopListModelCopyWithImpl<$Res, _$ShopListModelImpl>
    implements _$$ShopListModelImplCopyWith<$Res> {
  __$$ShopListModelImplCopyWithImpl(
    _$ShopListModelImpl _value,
    $Res Function(_$ShopListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shops = null}) {
    return _then(
      _$ShopListModelImpl(
        shops: null == shops
            ? _value._shops
            : shops // ignore: cast_nullable_to_non_nullable
                  as List<ShopModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopListModelImpl implements _ShopListModel {
  const _$ShopListModelImpl({required final List<ShopModel> shops})
    : _shops = shops;

  factory _$ShopListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopListModelImplFromJson(json);

  final List<ShopModel> _shops;
  @override
  List<ShopModel> get shops {
    if (_shops is EqualUnmodifiableListView) return _shops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shops);
  }

  @override
  String toString() {
    return 'ShopListModel(shops: $shops)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopListModelImpl &&
            const DeepCollectionEquality().equals(other._shops, _shops));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_shops));

  /// Create a copy of ShopListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopListModelImplCopyWith<_$ShopListModelImpl> get copyWith =>
      __$$ShopListModelImplCopyWithImpl<_$ShopListModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopListModelImplToJson(this);
  }
}

abstract class _ShopListModel implements ShopListModel {
  const factory _ShopListModel({required final List<ShopModel> shops}) =
      _$ShopListModelImpl;

  factory _ShopListModel.fromJson(Map<String, dynamic> json) =
      _$ShopListModelImpl.fromJson;

  @override
  List<ShopModel> get shops;

  /// Create a copy of ShopListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopListModelImplCopyWith<_$ShopListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopDetailModel _$ShopDetailModelFromJson(Map<String, dynamic> json) {
  return _ShopDetailModel.fromJson(json);
}

/// @nodoc
mixin _$ShopDetailModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get openingHours => throw _privateConstructorUsedError;
  String? get closingHours => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get totalReviews => throw _privateConstructorUsedError;

  /// Serializes this ShopDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopDetailModelCopyWith<ShopDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopDetailModelCopyWith<$Res> {
  factory $ShopDetailModelCopyWith(
    ShopDetailModel value,
    $Res Function(ShopDetailModel) then,
  ) = _$ShopDetailModelCopyWithImpl<$Res, ShopDetailModel>;
  @useResult
  $Res call({
    String id,
    String name,
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
  });
}

/// @nodoc
class _$ShopDetailModelCopyWithImpl<$Res, $Val extends ShopDetailModel>
    implements $ShopDetailModelCopyWith<$Res> {
  _$ShopDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? openingHours = freezed,
    Object? closingHours = freezed,
    Object? imageUrl = freezed,
    Object? rating = freezed,
    Object? totalReviews = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            openingHours: freezed == openingHours
                ? _value.openingHours
                : openingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            closingHours: freezed == closingHours
                ? _value.closingHours
                : closingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalReviews: freezed == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopDetailModelImplCopyWith<$Res>
    implements $ShopDetailModelCopyWith<$Res> {
  factory _$$ShopDetailModelImplCopyWith(
    _$ShopDetailModelImpl value,
    $Res Function(_$ShopDetailModelImpl) then,
  ) = __$$ShopDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
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
  });
}

/// @nodoc
class __$$ShopDetailModelImplCopyWithImpl<$Res>
    extends _$ShopDetailModelCopyWithImpl<$Res, _$ShopDetailModelImpl>
    implements _$$ShopDetailModelImplCopyWith<$Res> {
  __$$ShopDetailModelImplCopyWithImpl(
    _$ShopDetailModelImpl _value,
    $Res Function(_$ShopDetailModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? openingHours = freezed,
    Object? closingHours = freezed,
    Object? imageUrl = freezed,
    Object? rating = freezed,
    Object? totalReviews = freezed,
  }) {
    return _then(
      _$ShopDetailModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        openingHours: freezed == openingHours
            ? _value.openingHours
            : openingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        closingHours: freezed == closingHours
            ? _value.closingHours
            : closingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalReviews: freezed == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopDetailModelImpl implements _ShopDetailModel {
  const _$ShopDetailModelImpl({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.latitude,
    this.longitude,
    this.openingHours,
    this.closingHours,
    this.imageUrl,
    this.rating,
    this.totalReviews,
  });

  factory _$ShopDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopDetailModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? website;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? openingHours;
  @override
  final String? closingHours;
  @override
  final String? imageUrl;
  @override
  final double? rating;
  @override
  final int? totalReviews;

  @override
  String toString() {
    return 'ShopDetailModel(id: $id, name: $name, description: $description, address: $address, phone: $phone, email: $email, website: $website, latitude: $latitude, longitude: $longitude, openingHours: $openingHours, closingHours: $closingHours, imageUrl: $imageUrl, rating: $rating, totalReviews: $totalReviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours) &&
            (identical(other.closingHours, closingHours) ||
                other.closingHours == closingHours) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    address,
    phone,
    email,
    website,
    latitude,
    longitude,
    openingHours,
    closingHours,
    imageUrl,
    rating,
    totalReviews,
  );

  /// Create a copy of ShopDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopDetailModelImplCopyWith<_$ShopDetailModelImpl> get copyWith =>
      __$$ShopDetailModelImplCopyWithImpl<_$ShopDetailModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopDetailModelImplToJson(this);
  }
}

abstract class _ShopDetailModel implements ShopDetailModel {
  const factory _ShopDetailModel({
    required final String id,
    required final String name,
    final String? description,
    final String? address,
    final String? phone,
    final String? email,
    final String? website,
    final double? latitude,
    final double? longitude,
    final String? openingHours,
    final String? closingHours,
    final String? imageUrl,
    final double? rating,
    final int? totalReviews,
  }) = _$ShopDetailModelImpl;

  factory _ShopDetailModel.fromJson(Map<String, dynamic> json) =
      _$ShopDetailModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get website;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get openingHours;
  @override
  String? get closingHours;
  @override
  String? get imageUrl;
  @override
  double? get rating;
  @override
  int? get totalReviews;

  /// Create a copy of ShopDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopDetailModelImplCopyWith<_$ShopDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopDetailListModel _$ShopDetailListModelFromJson(Map<String, dynamic> json) {
  return _ShopDetailListModel.fromJson(json);
}

/// @nodoc
mixin _$ShopDetailListModel {
  List<ShopDetailModel> get shopDetails => throw _privateConstructorUsedError;

  /// Serializes this ShopDetailListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopDetailListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopDetailListModelCopyWith<ShopDetailListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopDetailListModelCopyWith<$Res> {
  factory $ShopDetailListModelCopyWith(
    ShopDetailListModel value,
    $Res Function(ShopDetailListModel) then,
  ) = _$ShopDetailListModelCopyWithImpl<$Res, ShopDetailListModel>;
  @useResult
  $Res call({List<ShopDetailModel> shopDetails});
}

/// @nodoc
class _$ShopDetailListModelCopyWithImpl<$Res, $Val extends ShopDetailListModel>
    implements $ShopDetailListModelCopyWith<$Res> {
  _$ShopDetailListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopDetailListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shopDetails = null}) {
    return _then(
      _value.copyWith(
            shopDetails: null == shopDetails
                ? _value.shopDetails
                : shopDetails // ignore: cast_nullable_to_non_nullable
                      as List<ShopDetailModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopDetailListModelImplCopyWith<$Res>
    implements $ShopDetailListModelCopyWith<$Res> {
  factory _$$ShopDetailListModelImplCopyWith(
    _$ShopDetailListModelImpl value,
    $Res Function(_$ShopDetailListModelImpl) then,
  ) = __$$ShopDetailListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ShopDetailModel> shopDetails});
}

/// @nodoc
class __$$ShopDetailListModelImplCopyWithImpl<$Res>
    extends _$ShopDetailListModelCopyWithImpl<$Res, _$ShopDetailListModelImpl>
    implements _$$ShopDetailListModelImplCopyWith<$Res> {
  __$$ShopDetailListModelImplCopyWithImpl(
    _$ShopDetailListModelImpl _value,
    $Res Function(_$ShopDetailListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopDetailListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shopDetails = null}) {
    return _then(
      _$ShopDetailListModelImpl(
        shopDetails: null == shopDetails
            ? _value._shopDetails
            : shopDetails // ignore: cast_nullable_to_non_nullable
                  as List<ShopDetailModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopDetailListModelImpl implements _ShopDetailListModel {
  const _$ShopDetailListModelImpl({
    required final List<ShopDetailModel> shopDetails,
  }) : _shopDetails = shopDetails;

  factory _$ShopDetailListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopDetailListModelImplFromJson(json);

  final List<ShopDetailModel> _shopDetails;
  @override
  List<ShopDetailModel> get shopDetails {
    if (_shopDetails is EqualUnmodifiableListView) return _shopDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shopDetails);
  }

  @override
  String toString() {
    return 'ShopDetailListModel(shopDetails: $shopDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopDetailListModelImpl &&
            const DeepCollectionEquality().equals(
              other._shopDetails,
              _shopDetails,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_shopDetails),
  );

  /// Create a copy of ShopDetailListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopDetailListModelImplCopyWith<_$ShopDetailListModelImpl> get copyWith =>
      __$$ShopDetailListModelImplCopyWithImpl<_$ShopDetailListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopDetailListModelImplToJson(this);
  }
}

abstract class _ShopDetailListModel implements ShopDetailListModel {
  const factory _ShopDetailListModel({
    required final List<ShopDetailModel> shopDetails,
  }) = _$ShopDetailListModelImpl;

  factory _ShopDetailListModel.fromJson(Map<String, dynamic> json) =
      _$ShopDetailListModelImpl.fromJson;

  @override
  List<ShopDetailModel> get shopDetails;

  /// Create a copy of ShopDetailListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopDetailListModelImplCopyWith<_$ShopDetailListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopCategoryModel _$ShopCategoryModelFromJson(Map<String, dynamic> json) {
  return _ShopCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$ShopCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this ShopCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopCategoryModelCopyWith<ShopCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCategoryModelCopyWith<$Res> {
  factory $ShopCategoryModelCopyWith(
    ShopCategoryModel value,
    $Res Function(ShopCategoryModel) then,
  ) = _$ShopCategoryModelCopyWithImpl<$Res, ShopCategoryModel>;
  @useResult
  $Res call({String id, String name, String? description, String? imageUrl});
}

/// @nodoc
class _$ShopCategoryModelCopyWithImpl<$Res, $Val extends ShopCategoryModel>
    implements $ShopCategoryModelCopyWith<$Res> {
  _$ShopCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopCategoryModelImplCopyWith<$Res>
    implements $ShopCategoryModelCopyWith<$Res> {
  factory _$$ShopCategoryModelImplCopyWith(
    _$ShopCategoryModelImpl value,
    $Res Function(_$ShopCategoryModelImpl) then,
  ) = __$$ShopCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? description, String? imageUrl});
}

/// @nodoc
class __$$ShopCategoryModelImplCopyWithImpl<$Res>
    extends _$ShopCategoryModelCopyWithImpl<$Res, _$ShopCategoryModelImpl>
    implements _$$ShopCategoryModelImplCopyWith<$Res> {
  __$$ShopCategoryModelImplCopyWithImpl(
    _$ShopCategoryModelImpl _value,
    $Res Function(_$ShopCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$ShopCategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopCategoryModelImpl implements _ShopCategoryModel {
  const _$ShopCategoryModelImpl({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory _$ShopCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'ShopCategoryModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, imageUrl);

  /// Create a copy of ShopCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopCategoryModelImplCopyWith<_$ShopCategoryModelImpl> get copyWith =>
      __$$ShopCategoryModelImplCopyWithImpl<_$ShopCategoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopCategoryModelImplToJson(this);
  }
}

abstract class _ShopCategoryModel implements ShopCategoryModel {
  const factory _ShopCategoryModel({
    required final String id,
    required final String name,
    final String? description,
    final String? imageUrl,
  }) = _$ShopCategoryModelImpl;

  factory _ShopCategoryModel.fromJson(Map<String, dynamic> json) =
      _$ShopCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get imageUrl;

  /// Create a copy of ShopCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopCategoryModelImplCopyWith<_$ShopCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopCategoryListModel _$ShopCategoryListModelFromJson(
  Map<String, dynamic> json,
) {
  return _ShopCategoryListModel.fromJson(json);
}

/// @nodoc
mixin _$ShopCategoryListModel {
  List<ShopCategoryModel> get shopCategories =>
      throw _privateConstructorUsedError;

  /// Serializes this ShopCategoryListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopCategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopCategoryListModelCopyWith<ShopCategoryListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCategoryListModelCopyWith<$Res> {
  factory $ShopCategoryListModelCopyWith(
    ShopCategoryListModel value,
    $Res Function(ShopCategoryListModel) then,
  ) = _$ShopCategoryListModelCopyWithImpl<$Res, ShopCategoryListModel>;
  @useResult
  $Res call({List<ShopCategoryModel> shopCategories});
}

/// @nodoc
class _$ShopCategoryListModelCopyWithImpl<
  $Res,
  $Val extends ShopCategoryListModel
>
    implements $ShopCategoryListModelCopyWith<$Res> {
  _$ShopCategoryListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopCategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shopCategories = null}) {
    return _then(
      _value.copyWith(
            shopCategories: null == shopCategories
                ? _value.shopCategories
                : shopCategories // ignore: cast_nullable_to_non_nullable
                      as List<ShopCategoryModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopCategoryListModelImplCopyWith<$Res>
    implements $ShopCategoryListModelCopyWith<$Res> {
  factory _$$ShopCategoryListModelImplCopyWith(
    _$ShopCategoryListModelImpl value,
    $Res Function(_$ShopCategoryListModelImpl) then,
  ) = __$$ShopCategoryListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ShopCategoryModel> shopCategories});
}

/// @nodoc
class __$$ShopCategoryListModelImplCopyWithImpl<$Res>
    extends
        _$ShopCategoryListModelCopyWithImpl<$Res, _$ShopCategoryListModelImpl>
    implements _$$ShopCategoryListModelImplCopyWith<$Res> {
  __$$ShopCategoryListModelImplCopyWithImpl(
    _$ShopCategoryListModelImpl _value,
    $Res Function(_$ShopCategoryListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopCategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shopCategories = null}) {
    return _then(
      _$ShopCategoryListModelImpl(
        shopCategories: null == shopCategories
            ? _value._shopCategories
            : shopCategories // ignore: cast_nullable_to_non_nullable
                  as List<ShopCategoryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopCategoryListModelImpl implements _ShopCategoryListModel {
  const _$ShopCategoryListModelImpl({
    required final List<ShopCategoryModel> shopCategories,
  }) : _shopCategories = shopCategories;

  factory _$ShopCategoryListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopCategoryListModelImplFromJson(json);

  final List<ShopCategoryModel> _shopCategories;
  @override
  List<ShopCategoryModel> get shopCategories {
    if (_shopCategories is EqualUnmodifiableListView) return _shopCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shopCategories);
  }

  @override
  String toString() {
    return 'ShopCategoryListModel(shopCategories: $shopCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopCategoryListModelImpl &&
            const DeepCollectionEquality().equals(
              other._shopCategories,
              _shopCategories,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_shopCategories),
  );

  /// Create a copy of ShopCategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopCategoryListModelImplCopyWith<_$ShopCategoryListModelImpl>
  get copyWith =>
      __$$ShopCategoryListModelImplCopyWithImpl<_$ShopCategoryListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopCategoryListModelImplToJson(this);
  }
}

abstract class _ShopCategoryListModel implements ShopCategoryListModel {
  const factory _ShopCategoryListModel({
    required final List<ShopCategoryModel> shopCategories,
  }) = _$ShopCategoryListModelImpl;

  factory _ShopCategoryListModel.fromJson(Map<String, dynamic> json) =
      _$ShopCategoryListModelImpl.fromJson;

  @override
  List<ShopCategoryModel> get shopCategories;

  /// Create a copy of ShopCategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopCategoryListModelImplCopyWith<_$ShopCategoryListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
