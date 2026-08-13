
// lib/features/ShopRegistration/presentation/widgets/ShopRegistration_app_bar.dart

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


import 'package:shared_ui/shared_ui.dart';

final logger = Logger();

class ShopRegistrationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopRegistrationAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.[cite: 10]
      backgroundColor: kTransparent,
      elevation: 0,

      // Judul AppBar.[cite: 10]
      title: Text(
        'ShopRegistration',
        style: TextStyle(
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}