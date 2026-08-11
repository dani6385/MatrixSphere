// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu
class DrawerItemData {
  final String title;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.route,
    this.onTap,
    required String label,
  });
}

// Daftar seluruh item menu yang sebelumnya menumpuk di satu file
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(title: 'Customers', icon: Icons.people, route: '', label: ''),
    DrawerItemData(title: 'Analytics', icon: Icons.analytics, route: '', label: ''),
    DrawerItemData(title: 'Integrations', icon: Icons.extension, route: '', label: ''),
    DrawerItemData(title: 'Support', icon: Icons.support_agent, route: '', label: ''),
    DrawerItemData(title: 'Feedback', icon: Icons.feedback, route: '', label: ''),
    DrawerItemData(
      title: 'Profile',
      icon: Icons.person,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      route: AppRoutes.profile,
      onTap: () {
        logger.i('Masuk ke Halaman Profile!');
        context.go(AppRoutes.profile);
      },
    ),
    DrawerItemData(title: 'Messages', icon: Icons.message, route: '', label: ''),
    DrawerItemData(
        title: 'Notifications', icon: Icons.notifications, route: '', label: ''),
    DrawerItemData(title: 'Team', icon: Icons.group, route: '', label: ''),
    DrawerItemData(title: 'Files', icon: Icons.folder, route: '', label: ''),
    DrawerItemData(title: 'Tasks', icon: Icons.task, route: '', label: ''),
    DrawerItemData(title: 'Calendar', icon: Icons.calendar_today, route: '', label: ''),
    DrawerItemData(title: 'Contacts', icon: Icons.contacts, route: '', label: ''),
    DrawerItemData(title: 'Returns', icon: Icons.assignment_return, route: '', label: ''),
    DrawerItemData(title: 'Vendors', icon: Icons.store, route: '', label: ''),
    DrawerItemData(title: 'Reviews', icon: Icons.reviews, route: '', label: ''),
    DrawerItemData(title: 'Marketing', icon: Icons.campaign, route: '', label: ''),
    DrawerItemData(title: 'Subscription', icon: Icons.subscriptions, route: '', label: ''),
    DrawerItemData(title: 'Billing', icon: Icons.credit_card, route: '', label: ''),
    DrawerItemData(title: 'API Keys', icon: Icons.vpn_key, route: '', label: ''),
    DrawerItemData(title: 'Audit Log', icon: Icons.history, route: '', label: ''),
    DrawerItemData(title: 'Webhooks', icon: Icons.webhook, route: '', label: ''),
    DrawerItemData(title: 'Templates', icon: Icons.copy, route: '', label: ''),
    DrawerItemData(title: 'Assets', icon: Icons.image, route: '', label: ''),
    DrawerItemData(title: 'Users', icon: Icons.people_alt, route: '', label: ''),
    DrawerItemData(title: 'Roles', icon: Icons.assignment_ind, route: '', label: ''),
    DrawerItemData(title: 'Permissions', icon: Icons.lock_open, route: '', label: ''),
  ];
}
