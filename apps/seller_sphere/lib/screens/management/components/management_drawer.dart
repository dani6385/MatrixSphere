// lib/screens/management/components/management_drawer.dart

import 'package:flutter/material.dart';
import 'items/management_drawer_items.dart';

class ManagementDrawer extends StatelessWidget {
  const ManagementDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rute saat ini untuk menyorot item yang aktif
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final List<DrawerItemData> drawerItems = getDrawerItems(context, currentRoute);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu Manajemen',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ...drawerItems.map((item) {
            final bool isSelected = item.route.isNotEmpty && item.route == currentRoute;
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              selected: isSelected,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onTap: () {
                // Tutup drawer terlebih dahulu
                Navigator.pop(context);
                // Jalankan aksi onTap jika ada
                item.onTap?.call();
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}