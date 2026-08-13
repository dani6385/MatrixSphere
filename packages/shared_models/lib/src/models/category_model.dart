
library category_model;

/// Model untuk kategori produk.
class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}