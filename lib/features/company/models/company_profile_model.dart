class CompanyProfileModel {
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? description;
  final String? logoUrl;

  const CompanyProfileModel({
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.description,
    this.logoUrl,
  });

  bool get hasLogo => logoUrl != null && logoUrl!.trim().isNotEmpty;

  factory CompanyProfileModel.fromMap(Map<dynamic, dynamic>? map) {
    return CompanyProfileModel(
      name: map?['name']?.toString() ?? 'Nama Perusahaan',
      email: map?['email']?.toString() ?? '-',
      phone: map?['phone']?.toString(),
      address: map?['address']?.toString(),
      description: map?['description']?.toString(),
      logoUrl: map?['logoUrl']?.toString(),
    );
  }
}