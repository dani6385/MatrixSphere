import 'package:shared_models/shared_models.dart';

/// Model untuk item dalam keranjang belanja.
///
/// Menyimpan referensi ke produk dan jumlah yang dibeli.
class ItemCart {
  final Product product;
  int quantity;

  ItemCart({
    required this.product,
    required this.quantity,
    required String productId,
    required String productName,
    required double sellingPrice,
  });
}
