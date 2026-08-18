import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// A universal drawer widget that can be configured with a header and a list of items.
///
/// It uses the `SideMenu` widget from the `shared_ui` package to display the menu.
class UniversalDrawer extends StatelessWidget {
  final Widget header;
  final List<SideMenuItem> items;
  final String? selectedRoute;

  const UniversalDrawer({
    super.key,
    required this.header,
    required this.items,
    this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header,
      items: items,
      // Jika selectedRoute tidak null, gunakan itu. Jika null, biarkan SideMenu yang menangani.
      // Ini penting agar highlight pada item yang dipilih berfungsi dengan benar.
      selectedRoute: selectedRoute ?? '',
      // children: null karena kita hanya menampilkan item utama.
      children: null,
    );
  }
}