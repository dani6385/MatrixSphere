class CompanyProfileModel {
  final String name;
  final String tagline;
  final String industry;
  final String email;
  final String phone;
  final String website;
  final String address;
  final String? logoUrl;
  final String vision;   // <-- BARU
  final String mission;  // <-- BARU

  const CompanyProfileModel({
    required this.name,
    required this.tagline,
    required this.industry,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    this.logoUrl,
    required this.vision,
    required this.mission,
  });

  factory CompanyProfileModel.fromMap(Map<dynamic, dynamic>? map) {
    final data = map ?? {};
    final rawLogo = data['logoUrl']?.toString();

    return CompanyProfileModel(
      name: (data['name']?.toString().isNotEmpty == true)
          ? data['name'].toString()
          : 'Matrix Sphere Indonesia',
      tagline: (data['tagline']?.toString().isNotEmpty == true)
          ? data['tagline'].toString()
          : 'Solusi Infrastruktur & Digital Terpadu',
      industry: (data['industry']?.toString().isNotEmpty == true)
          ? data['industry'].toString()
          : 'Teknologi & Operasional',
      email: (data['email']?.toString().isNotEmpty == true)
          ? data['email'].toString()
          : 'info@matrixsphere.id',
      phone: (data['phone']?.toString().isNotEmpty == true)
          ? data['phone'].toString()
          : 'Belum diisi',
      website: (data['website']?.toString().isNotEmpty == true)
          ? data['website'].toString()
          : 'Belum diisi',
      address: (data['address']?.toString().isNotEmpty == true)
          ? data['address'].toString()
          : 'Belum diisi',
      logoUrl: (rawLogo != null && rawLogo.isNotEmpty) ? rawLogo : null,
      vision: (data['vision']?.toString().isNotEmpty == true)
          ? data['vision'].toString()
          : 'Belum diisi',
      mission: (data['mission']?.toString().isNotEmpty == true)
          ? data['mission'].toString()
          : 'Belum diisi',
    );
  }

  bool get hasLogo => logoUrl != null && logoUrl!.isNotEmpty;
}