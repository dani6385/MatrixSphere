// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';


final Logger logger = Logger();

// Definisi struktur data untuk item menu
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label;
  
  
  final VoidCallback? ontap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    this.ontap,
  });
}

// Daftar seluruh item menu yang sebelumnya menumpuk di satu file
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(title: 'Customers', icon: Icons.people, label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Analytics', icon: Icons.analytics, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Integrations', icon: Icons.extension, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Support', icon: Icons.support_agent, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Feedback', icon: Icons.feedback, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Profile', icon: Icons.person, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Messages', icon: Icons.message, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(
        title: 'Notifications', icon: Icons.notifications, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Team', icon: Icons.group, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Files', icon: Icons.folder, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Tasks', icon: Icons.task, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Calendar', icon: Icons.calendar_today, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Contacts', icon: Icons.contacts, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Returns', icon: Icons.assignment_return, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Vendors', icon: Icons.store, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Reviews', icon: Icons.reviews, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Marketing', icon: Icons.campaign, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Subscription', icon: Icons.subscriptions, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Billing', icon: Icons.credit_card, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'API Keys', icon: Icons.vpn_key, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Audit Log', icon: Icons.history, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Webhooks', icon: Icons.webhook, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Templates', icon: Icons.copy, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Assets', icon: Icons.image, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Users', icon: Icons.people_alt, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Roles', icon: Icons.assignment_ind, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
    DrawerItemData(title: 'Permissions', icon: Icons.lock_open, label: '', ontap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push('');
      },
    ),
  ];
}
