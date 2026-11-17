import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: Colors.blue.shade100,
          backgroundImage:
              profile.hasPhoto ? NetworkImage(profile.photoUrl!) : null,
          child: !profile.hasPhoto
              ? const Icon(Icons.person, size: 60, color: Colors.blue)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}