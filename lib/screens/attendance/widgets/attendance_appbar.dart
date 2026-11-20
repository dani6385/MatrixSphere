import 'package:flutter/material.dart';

class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefreshLocation;

  const AttendanceAppBar({
    super.key,
    required this.onRefreshLocation,
    required void Function() onOpenDrawer,
    required void Function() onOpenEndDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Absensi Wajah & Lokasi"),
      backgroundColor: Colors.blueAccent,
      actions: [
        IconButton(
          tooltip: 'Profil & Akun',
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {
            Scaffold.maybeOf(context)?.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
