import 'package:flutter/material.dart';

/// Kerangka AppBar opsional untuk halaman login.
/// Mengimplementasikan `PreferredSizeWidget` agar bisa dipasang pada `Scaffold.appBar`.
class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const LoginAppBar({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: title.isNotEmpty ? Text(title) : null,
    );
  }
}