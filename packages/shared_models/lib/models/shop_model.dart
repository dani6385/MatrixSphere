import 'package:flutter/foundation.dart';

@immutable
class Shop {
  final String id;
  final String ownerId;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? logoUrl;
  final String? address;
  final Map<String, dynamic> products;
  final double? latitude;
  final double? longitude;

  const Shop({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.email,
    required this.createdAt,
    this.logoUrl,
    this.address,
    this.products = const {},
    this.latitude,
    this.longitude,
  });

  // Konversi dari Map (data dari Firebase) ke objek Shop
  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      logoUrl: map['logoUrl'] as String?,
      address: map['address'] as String?,
      products: Map<String, dynamic>.from(map['products'] ?? {}),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  // Konversi dari objek Shop ke Map (untuk disimpan ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'logoUrl': logoUrl,
      'address': address,
      'products': products,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  static Shop? fromJson(String s, Map<String, dynamic> shopData) {
    return null;
  }
}
