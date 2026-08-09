import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class InventoryService {
  // Referensi ke Realtime Database
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final Logger _logger = Logger();

  Future<void> decreaseStock(String productId, int quantityToSubtract) async {
    try {
      final productRef = _dbRef.child('products').child(productId).child('stock');

      await productRef.runTransaction((mutableData) async {
        int currentStock = (mutableData.value ?? 0) as int;
        _logger.d('Current stock for product $productId: $currentStock');

        if (currentStock < quantityToSubtract) {
          _logger.w('Attempted to subtract $quantityToSubtract from stock $currentStock for product $productId. Not enough stock.');
          // Optionally, you can throw an error or return null to abort the transaction
          // For now, we'll just prevent negative stock and log a warning.
          mutableData.value = currentStock; // Keep current stock if not enough
          return mutableData;
        }

        mutableData.value = currentStock - quantityToSubtract;
        _logger.d('New stock for product $productId: ${mutableData.value}');
        return mutableData;
      } as TransactionHandler);
      _logger.i('Stock for product $productId decreased by $quantityToSubtract successfully.');
    } catch (e) {
      _logger.e('Failed to decrease stock for product $productId: $e');
      rethrow; // Re-throw the exception for upstream error handling
    }
    
  }

  Future<void> increaseStock(String productId, int quantityToAdd) async {
    try {
      final productRef = _dbRef.child('products').child(productId).child('stock');

      await productRef.runTransaction((mutableData) async {
        int currentStock = (mutableData.value ?? 0) as int;
        _logger.d('Current stock for product $productId: $currentStock');

        mutableData.value = currentStock + quantityToAdd;
        _logger.d('New stock for product $productId: ${mutableData.value}');
        return mutableData;
      } as TransactionHandler);
      _logger.i('Stock for product $productId increased by $quantityToAdd successfully.');
    } catch (e) {
      _logger.e('Failed to increase stock for product $productId: $e');
      rethrow; // Re-throw the exception for upstream error handling
    }
  }
  Future<int> getStock(String productId) async {
    try {
      final productRef = _dbRef.child('products').child(productId).child('stock');
      final snapshot = await productRef.get();

      if (snapshot.exists) {
        final stock = snapshot.value;
        if (stock is int) {
          _logger.d('Retrieved stock for product $productId: $stock');
          return stock;
        } else {
          _logger.w('Stock for product $productId is not an integer: $stock');
          return 0; // Or throw an error, depending on desired behavior
        }
      } else {
        _logger.w('Stock for product $productId not found. Assuming 0.');
        return 0;
      }
    } catch (e) {
      _logger.e('Failed to get stock for product $productId: $e');
      rethrow;
    }
  }
  Future<void> updateStock(String productId, int newStock) async {
    try {
      final productRef = _dbRef.child('products').child(productId).child('stock');
      await productRef.set(newStock);
      _logger.i('Stock for product $productId updated to $newStock successfully.');
    } catch (e) {
      _logger.e('Failed to update stock for product $productId to $newStock: $e');
      rethrow;
    }
  }
  Future<bool> hasSufficientStock(String productId, int quantityNeeded) async {
    try {
      final currentStock = await getStock(productId);
      _logger.d('Checking sufficient stock for product $productId. Current: $currentStock, Needed: $quantityNeeded');
      return currentStock >= quantityNeeded;
      
    } catch (e) {
      _logger.e('Failed to check sufficient stock for product $productId: $e');
      rethrow;
    }
  }
}
