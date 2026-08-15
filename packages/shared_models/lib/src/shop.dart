import 'package:equatable/equatable.dart';

class Shop extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;

  const Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
  });

  @override
  List<Object> get props => [id, name, description, ownerId];

  // Konversi dari Map (Firestore) ke objek Shop
  factory Shop.fromJson(Map<String, dynamic> json, String id) {
    return Shop(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String,
    );
  }

  // Konversi dari objek Shop ke Map (untuk Firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ownerId': ownerId,
    };
  }
}
