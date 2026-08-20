// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label;

  final VoidCallback? ontap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    this.ontap,
  });
}

// Daftar seluruh item menu yang sebelumnya menumpuk di satu file
List<MenuDrawer> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Absen',
      icon: Icons.people,
      label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      ontap: () {
        logger.i('Navigasi ke Scanner Absensi');
        context.push(AppRoutes.scanFace);
      },
    ),
    MenuDrawer(
      title: 'Scan QR',
      icon: Icons.analytics,
      label: '',
      ontap: () {
        logger.i('Navigasi ke Scanner Produk');
        context.push(AppRoutes.scanQr);
      },
    ),
    MenuDrawer(
      title: 'Integrations',
      icon: Icons.extension,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Support',
      icon: Icons.support_agent,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Feedback',
      icon: Icons.feedback,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Profile',
      icon: Icons.person,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Messages',
      icon: Icons.message,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Notifications',
      icon: Icons.notifications,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Team',
      icon: Icons.group,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Files',
      icon: Icons.folder,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Tasks',
      icon: Icons.task,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Calendar',
      icon: Icons.calendar_today,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Contacts',
      icon: Icons.contacts,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Returns',
      icon: Icons.assignment_return,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Vendors',
      icon: Icons.store,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Reviews',
      icon: Icons.reviews,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Marketing',
      icon: Icons.campaign,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Subscription',
      icon: Icons.subscriptions,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Billing',
      icon: Icons.credit_card,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'API Keys',
      icon: Icons.vpn_key,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Audit Log',
      icon: Icons.history,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Webhooks',
      icon: Icons.webhook,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Templates',
      icon: Icons.copy,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Assets',
      icon: Icons.image,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Users',
      icon: Icons.people_alt,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Roles',
      icon: Icons.assignment_ind,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    MenuDrawer(
      title: 'Permissions',
      icon: Icons.lock_open,
      label: '',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
  ];
}

List<SideMenuItem> getDrawerSideMenuItems(
    BuildContext context, String currentRoute) {
  final drawerItems = getDrawerItems(context, currentRoute);

  return drawerItems.map((item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: '', // Sesuaikan rute jika diperlukan
      isSelected: false,
      onTap: item.ontap ??
          () {}, // Provide an empty function if item.onTap is null
    );
  }).toList();
}
