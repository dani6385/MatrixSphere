
library product_category_model;


/// Model untuk kategori produk.
class ProductCategory {
  final String id;
  final String name;
  final String? imageUrl; // Optional: for category icon/image

  ProductCategory({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory ProductCategory.fromMap(Map<String, dynamic> map, String id) {
    return ProductCategory(
      id: id,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
