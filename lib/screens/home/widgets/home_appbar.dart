import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';

/// AppBar khusus untuk halaman utama (`HomeScreen`) pada Matrix Sphere.
/// Mengimplementasikan `PreferredSizeWidget` agar dapat dipasang langsung pada
/// properti `appBar: const HomeAppBar()` di dalam `Scaffold`.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Judul yang ditampilkan di bilah atas aplikasi.
  final String title;

  const HomeAppBar({super.key, this.title = 'Matrix Sphere'});

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
        // Tombol notifikasi -> mengarah ke halaman Notifications via AppNavigation
        IconButton(
          tooltip: 'Notifikasi',
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => AppNavigation.openNotifications(context),
        ),
        IconButton(
          tooltip: 'Chat',
          icon: const Icon(Icons.chat_bubble),
          onPressed: () => AppNavigation.openMessages(context),
        ),
        // Tombol membuka endDrawer profil pengguna pada HomeScreen
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
