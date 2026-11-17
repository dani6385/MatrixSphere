import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'models/user_profile_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Sesi pengguna tidak ditemukan.')),
      );
    }

    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${currentUser.uid}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToHome(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profil',
            onPressed: () => context.pushToUserEditProfile(),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<dynamic, dynamic>? rawData;
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          final profile = UserProfileModel.fromSources(currentUser, rawData);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ProfileHeader(profile: profile),
                const SizedBox(height: 24),
                ProfileInfoCard(profile: profile),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Ubah Data Profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => context.pushToUserEditProfile(),
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