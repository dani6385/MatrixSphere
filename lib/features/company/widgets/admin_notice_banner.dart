import 'package:flutter/material.dart';

class AdminNoticeBanner extends StatelessWidget {
  final bool isAdmin;

  const AdminNoticeBanner({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    if (isAdmin) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        'Mode lihat saja: hanya Admin yang dapat mengubah data dan jam kerja.',
      ),
    );
  }
}