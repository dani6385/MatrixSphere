// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoUrl: json['photoUrl'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  address: json['address'] as String?,
  role: json['role'] as String? ?? 'customer',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastSignInAt: json['lastSignInAt'] == null
      ? null
      : DateTime.parse(json['lastSignInAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'role': instance.role,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastSignInAt': instance.lastSignInAt?.toIso8601String(),
};
