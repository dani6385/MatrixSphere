import 'package:flutter/foundation.dart';

@immutable
class ShopOrder {
  final String id;
  final String ownerId;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? logoUrl;
  final String? address;

  const ShopOrder({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.email,
    required this.createdAt,
    this.logoUrl,
    this.address,
  });

  // Konversi dari Map (data dari Firebase) ke objek Shop
  factory ShopOrder.fromMap(Map<String, dynamic> map) {
    return ShopOrder(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      logoUrl: map['logoUrl'] as String?,
      address: map['address'] as String?,
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
    };
  }
}

class ShopPacking {
  final String id;
  final Map<String, dynamic> products;
  final double? latitude;
  final double? longitude;

  ShopPacking({
    required this.id,
    this.products = const {},
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'produk': products,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static ShopPacking? fromJson(String id, Map<String, dynamic> json) {
    return ShopPacking(
      id: id,
      products: json['produk'] != null
          ? Map<String, dynamic>.from(json['produk'])
          : {},
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}