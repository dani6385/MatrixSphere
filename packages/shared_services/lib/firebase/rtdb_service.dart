import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for reading and writing Firebase Realtime Database (RTDB)
/// across Matrix Sphere, Seller Sphere, Shop Sphere, and Client Connect.
class RtdbService {
  final FirebaseDatabase _database;
  final FirebaseAuth _auth;

  RtdbService({
    FirebaseDatabase? database,
    FirebaseAuth? auth,
  })  : _database = database ?? FirebaseDatabase.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Current authenticated user UID (null if not signed in).
  String? get currentUid => _auth.currentUser?.uid;

  /// Returns a [DatabaseReference] for the given [path].
  DatabaseReference ref(String path) => _database.ref(path);

  /// Generates a new unique push key for a given [path].
  String? newKey(String path) => _database.ref(path).push().key;

  // ===========================================================================
  // GENERIC READ, WRITE, UPDATE, DELETE & STREAM HELPERS
  // ===========================================================================

  /// Reads a single snapshot from [path].
  Future<DataSnapshot> getSnapshot(String path) async {
    try {
      return await _database.ref(path).get();
    } catch (e, stack) {
      _logError('getSnapshot($path)', e, stack);
      rethrow;
    }
  }

  /// Reads data from [path] and maps it to [T] if available.
  Future<T?> getValue<T>(
    String path, {
    T Function(Map<String, dynamic> json, String key)? fromMap,
  }) async {
    try {
      final snapshot = await _database.ref(path).get();
      if (!snapshot.exists || snapshot.value == null) return null;

      if (fromMap != null && snapshot.value is Map) {
        final map = _castMap(snapshot.value!);
        return fromMap(map, snapshot.key ?? '');
      }
      return snapshot.value as T?;
    } catch (e, stack) {
      _logError('getValue($path)', e, stack);
      rethrow;
    }
  }

  /// Reads a list of items from [path] (e.g., `/products`, `/orders`, `/client_tickets`).
  Future<List<T>> getList<T>(
    String path, {
    required T Function(Map<String, dynamic> json, String key) fromMap,
    String? orderByChild,
    Object? equalTo,
  }) async {
    try {
      Query query = _database.ref(path);
      if (orderByChild != null) {
        query = query.orderByChild(orderByChild);
        if (equalTo != null) {
          query = query.equalTo(equalTo);
        }
      }

      final snapshot = await query.get();
      if (!snapshot.exists || snapshot.value == null) return [];

      return _mapSnapshotToList(snapshot, fromMap);
    } catch (e, stack) {
      _logError('getList($path)', e, stack);
      rethrow;
    }
  }

  /// Watches real-time changes on [path] as a typed value.
  /*Stream<T?> watchValue<T>(
    String path, {
    T Function(Map<String, dynamic> json, String key)? fromMap,
  }) {
    return _database.ref(path).onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) return null;

      if (fromMap != null && snapshot.value is Map) {
        final map = _castMap(snapshot.value!);
        return fromMap(map, snapshot.key ?? '');
      }
      return snapshot.value as T?;
    });
  }*/

  /// Watches real-time changes on [path] as a list of items.
  /*Stream<List<T>> watchList<T>(
    String path, {
    required T Function(Map<String, dynamic> json, String key) fromMap,
    String? orderByChild,
    Object? equalTo,
  }) {
    Query query = _database.ref(path);
    if (orderByChild != null) {
      query = query.orderByChild(orderByChild);
      if (equalTo != null) {
        query = query.equalTo(equalTo);
      }
    }

    return query.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) return <T>[];
      return _mapSnapshotToList(snapshot, fromMap);
    });
  }*/

  /// Overwrites data at [path] using `set()`.
  Future<void> setData(String path, Object? value) async {
    try {
      await _database.ref(path).set(value);
    } catch (e, stack) {
      _logError('setData($path)', e, stack);
      rethrow;
    }
  }

  /// Partially updates fields at [path] using `update()`.
  Future<void> updateData(String path, Map<String, Object?> updates) async {
    try {
      await _database.ref(path).update(updates);
    } catch (e, stack) {
      _logError('updateData($path)', e, stack);
      rethrow;
    }
  }

  /// Pushes a new child record under [path] and returns the generated key.
  Future<String> pushData(String path, Map<String, Object?> data) async {
    try {
      final newRef = _database.ref(path).push();
      await newRef.set(data);
      return newRef.key!;
    } catch (e, stack) {
      _logError('pushData($path)', e, stack);
      rethrow;
    }
  }

  /// Deletes data at [path].
  Future<void> removeData(String path) async {
    try {
      await _database.ref(path).remove();
    } catch (e, stack) {
      _logError('removeData($path)', e, stack);
      rethrow;
    }
  }

  /// Executes an atomic multi-path update (ideal for approving a shop,
  /// updating order + stock together, etc.).
  Future<void> multiPathUpdate(Map<String, Object?> pathsWithValues) async {
    try {
      await _database.ref().update(pathsWithValues);
    } catch (e, stack) {
      _logError('multiPathUpdate', e, stack);
      rethrow;
    }
  }

  /// Runs a transaction on [path] (ideal for stock counters or `soldCount`).
  Future<TransactionResult> runTransaction(
    String path,
    TransactionResult Function(Object? currentData) updateHandler,
  ) async {
    try {
      return await _database.ref(path).runTransaction(updateHandler as TransactionHandler);
    } catch (e, stack) {
      _logError('runTransaction($path)', e, stack);
      rethrow;
    }
  }

  // ===========================================================================
  // DOMAIN HELPERS FOR ECOSYSTEM NODES
  // ===========================================================================

  /// Users node: `/users/$uid`
  Future<void> upsertUserProfile(
    String uid,
    Map<String, Object?> profileData,
  ) =>
      updateData('users/$uid', profileData);

  /*Stream?> watchUserProfile(String uid) =>
      watchValue>(
        'users/$uid',
        fromMap: (json, _) => json,
      );*/

  /// Matrix Sphere helpers
  Future<void> setMatrixAttendance(
    String uid,
    String dateKey,
    Map<String, Object?> attendanceData,
  ) =>
      setData('attendance/matrix/$uid/$dateKey', attendanceData);

  /// Seller Sphere helpers
  Future<String> createProduct(Map<String, Object?> productData) =>
      pushData('products', productData);

  Future<void> updateProduct(String productId, Map<String, Object?> updates) =>
      updateData('products/$productId', updates);

  Future<void> logStockChange(
    String productId,
    Map<String, Object?> logData,
  ) =>
      pushData('stock_logs/$productId', logData);

  /// Shop Sphere helpers
  Future<String> createOrder({
    required String shopId,
    required Map<String, Object?> items,
    required num totalAmount,
    Map<String, Object?> extraFields = const {},
  }) async {
    final uid = currentUid;
    if (uid == null) {
      throw StateError('User must be authenticated to create an order.');
    }

    final payload = <String, Object?>{
      'shopId': shopId,
      'buyerId': uid,
      'items': items,
      'totalAmount': totalAmount,
      'createdAt': ServerValue.timestamp,
      'status': 'pending',
      ...extraFields,
    };

    return pushData('orders', payload);
  }

  Future<void> updateOrderStatus(String orderId, String status) =>
      updateData('orders/$orderId', {'status': status});

  /// Client Connect helpers
  Future<void> upsertClientConnect(
    String uid,
    Map<String, Object?> clientData,
  ) =>
      updateData('client_connect/$uid', clientData);

  Future<String> createClientTicket({
    required String title,
    required String status,
    Map<String, Object?> extraFields = const {},
  }) async {
    final uid = currentUid;
    if (uid == null) {
      throw StateError('User must be authenticated to create a ticket.');
    }

    final payload = <String, Object?>{
      'clientUid': uid,
      'title': title,
      'status': status,
      'createdAt': ServerValue.timestamp,
      ...extraFields,
    };

    return pushData('client_tickets', payload);
  }

  /// App errors logger: `/app_errors`
  Future<void> logAppError({
    required String source,
    required Object error,
    StackTrace? stackTrace,
  }) async {
    try {
      await _database.ref('app_errors').push().set({
        'uid': currentUid ?? 'anonymous',
        'source': source,
        'error': error.toString(),
        'stackTrace': stackTrace?.toString() ?? '',
        'timestamp': ServerValue.timestamp,
      });
    } catch (_) {
      // Avoid throwing secondary errors while reporting an error.
    }
  }

  // ===========================================================================
  // INTERNAL MAPPING & LOGGING HELPERS
  // ===========================================================================

  List<T> _mapSnapshotToList<T>(
    DataSnapshot snapshot,
    T Function(Map<String, dynamic> json, String key) fromMap,
  ) {
    final result = <T>[];
    for (final child in snapshot.children) {
      final key = child.key ?? '';
      if (child.value is Map) {
        result.add(fromMap(_castMap(child.value!), key));
      }
    }
    return result;
  }

  Map<String, dynamic> _castMap(Object raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), _normalizeValue(value)),
      );
    }
    return <String, dynamic>{};
  }

  Object? _normalizeValue(Object? value) {
    if (value is Map) {
      return _castMap(value);
    }
    if (value is List) {
      return value.map(_normalizeValue).toList();
    }
    return value;
  }

  void _logError(String method, Object error, StackTrace stack) {
    if (kDebugMode) {
      debugPrint('[RTDB] Error in $method: $error\n$stack');
    }
  }
}

/// Global instance to use across the app (matching `analyticsService` style).
final rtdbService = RtdbService();