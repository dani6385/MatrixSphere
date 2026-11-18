import 'package:firebase_auth/firebase_auth.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String address;
  final String? photoUrl;

  const UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    this.photoUrl,
  });

  /// Mengonversi data mentah RTDB dan FirebaseAuth menjadi objek yang rapi
  factory UserProfileModel.fromSources(
    User authUser,
    Map<dynamic, dynamic>? rtdbData,
  ) {
    final data = rtdbData ?? {};
    final rawPhoto = data['photoUrl']?.toString() ?? authUser.photoURL;

    return UserProfileModel(
      uid: authUser.uid,
      name: (data['name']?.toString().isNotEmpty == true)
          ? data['name'].toString()
          : (authUser.displayName ?? 'Pengguna Matrix Sphere'),
      email: authUser.email ?? '-',
      phone: (data['phone']?.toString().isNotEmpty == true)
          ? data['phone'].toString()
          : 'Belum diisi',
      role: (data['role']?.toString().isNotEmpty == true)
          ? data['role'].toString()
          : 'Administrator',
      address: (data['address']?.toString().isNotEmpty == true)
          ? data['address'].toString()
          : 'Belum diisi',
      photoUrl: (rawPhoto != null && rawPhoto.isNotEmpty) ? rawPhoto : null,
    );
  }

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;
}