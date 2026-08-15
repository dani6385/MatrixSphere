import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ShopRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ShopRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> createShop(
      {required String name, required String description}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Tidak ada pengguna yang diautentikasi.');
    }

    try {
      // Membuat dokumen baru di koleksi 'shops'
      await _firestore.collection('shops').add({
        'name': name,
        'description': description,
        'ownerId': currentUser.uid, // Menetapkan pemilik toko
        'createdAt': FieldValue.serverTimestamp(), // Menambahkan timestamp
      });
    } on FirebaseException catch (e) {
      // Menangani error spesifik dari Firestore
      if (kDebugMode) {
        print('Firestore Error: ${e.message}');
      }
      throw Exception('Gagal menyimpan toko ke Firestore: ${e.code}');
    } catch (e) {
      // Menangani error umum lainnya
      if (kDebugMode) {
        print('Generic Error: $e');
      }
      throw Exception('Terjadi kesalahan tak terduga.');
    }
  }
}
