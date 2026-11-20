/// Model data untuk profil perusahaan pada Matrix Sphere.
/// Membantu mengubah data mentah dari Firebase Realtime Database menjadi objek
/// yang aman dan mudah dipakai di UI (seperti `HomeScreen` dan `CompanyProfileScreen`).
class CompanyProfileModel {
  final String name;
  final String email;
  final String? logoUrl;
  final String? phone;
  final String? address;
  final String? description;

  const CompanyProfileModel({
    required this.name,
    required this.email,
    this.logoUrl,
    this.phone,
    this.address,
    this.description,
  });

  /// Mengembalikan `true` jika `logoUrl` ada dan tidak kosong[cite: 6].
  bool get hasLogo => logoUrl != null && logoUrl!.trim().isNotEmpty;

  /// Membuat `CompanyProfileModel` dari `Map` (misalnya hasil snapshot Firebase RTDB)[cite: 6].
  factory CompanyProfileModel.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const CompanyProfileModel(
        name: 'Matrix Sphere Company',
        email: 'company@matrixsphere.local',
      );
    }

    // Mendukung beberapa kemungkinan nama key agar tetap aman saat migrasi data
    final String rawName = (map['name'] ?? map['companyName'] ?? '').toString().trim();
    final String rawEmail = (map['email'] ?? map['companyEmail'] ?? '').toString().trim();
    final String rawLogo = (map['logoUrl'] ?? map['logo_url'] ?? '').toString().trim();
    final String rawPhone = (map['phone'] ?? '').toString().trim();
    final String rawAddress = (map['address'] ?? '').toString().trim();
    final String rawDescription = (map['description'] ?? '').toString().trim();

    return CompanyProfileModel(
      name: rawName.isNotEmpty ? rawName : 'Matrix Sphere Company',
      email: rawEmail.isNotEmpty ? rawEmail : 'company@matrixsphere.local',
      logoUrl: rawLogo.isNotEmpty ? rawLogo : null,
      phone: rawPhone.isNotEmpty ? rawPhone : null,
      address: rawAddress.isNotEmpty ? rawAddress : null,
      description: rawDescription.isNotEmpty ? rawDescription : null,
    );
  }

  /// Mengubah `CompanyProfileModel` kembali menjadi `Map<String, dynamic>`
  /// untuk disimpan ke Firebase Realtime Database.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (description != null) 'description': description,
    };
  }
}