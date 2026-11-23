import 'package:flutter/material.dart';

/// AppBar khusus untuk halaman utama (`AttendanceScreen`) pada Matrix Sphere.
/// Mengimplementasikan `PreferredSizeWidget` agar dapat dipasang langsung pada
/// properti `appBar: const AttendanceAppBar()` di dalam `Scaffold`.
class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Judul yang ditampilkan di bilah atas aplikasi.
  final String title;

  const AttendanceAppBar({super.key, this.title = 'Matrix Sphere'});

  /// Menentukan tinggi standar AppBar Material (56.0 px).
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Tombol membuka endDrawer profil pengguna pada AttendanceScreen
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
}
