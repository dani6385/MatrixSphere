
import 'package:shared_services/shared_services.dart';

mixin ProductManager {
  List<Product> products = [];
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();

  Future<void> fetchProducts(String streamId, Function() notify) async {
    try {
      final snapshot = await _rtdbService.readData('seller_sphere/$streamId/produk');
      if (snapshot != null && snapshot.exists && snapshot.value != null) {
        final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
        products = productsMap.entries.map((entry) {
          return Product.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
    }
    notify();
  }
}