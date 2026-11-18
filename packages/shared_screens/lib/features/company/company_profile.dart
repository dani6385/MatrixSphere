import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'models/company_profile_model.dart';
import 'widgets/company_info_card.dart';
import 'widgets/visi_misi.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  /// Mengecek apakah pengguna saat ini memiliki klaim Admin di Firebase Auth
  Future<void> _checkAdminRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final idTokenResult = await user.getIdTokenResult();
      final isAdminClaim = idTokenResult.claims?['isAdmin'] == true;
      if (mounted) {
        setState(() => _isAdmin = isAdminClaim);
      }
    } catch (e) {
      debugPrint('Gagal memeriksa status admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference companyRef = FirebaseDatabase.instance.ref(
      'company_profile',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Perusahaan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToHome(context),
        ),
        actions: [
          // Tombol edit hanya muncul jika pengguna adalah Admin
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profil Perusahaan',
              onPressed: () => context.pushToCompanyEditProfile(),
            ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: companyRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<dynamic, dynamic>? rawData;
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          final company = CompanyProfileModel.fromMap(rawData);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Logo Perusahaan
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade200, width: 2),
                    image: company.hasLogo
                        ? DecorationImage(
                            image: NetworkImage(company.logoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !company.hasLogo
                      ? const Icon(
                          Icons.apartment,
                          size: 56,
                          color: Colors.blue,
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // Nama & Slogan Perusahaan
                Text(
                  company.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company.tagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Kartu Informasi Lengkap
                CompanyInfoCard(company: company),
                const SizedBox(height: 24),
                CompanyInfoCard(company: company),
                const SizedBox(height: 16),

                // 4. KARTU VISI & MISI (TAMBAHKAN INI)
                VisionMision(company: company),
                const SizedBox(height: 24),
                // Tombol Edit Bawah (Khusus Admin)
                if (_isAdmin)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Ubah Profil Perusahaan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => context.pushToCompanyEditProfile(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
