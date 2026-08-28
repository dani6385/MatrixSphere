import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';


// 1. Definisikan helper di luar class agar bisa dipanggil secara global
// Sesuaikan return type dengan apa yang diminta oleh SharedBottomNavBar (yaitu GButton)
List<GButton> getBottomNavBarItems(AppType appType) {
  List<PageType> pages = getNavbarItems(appType);

  return pages.map((page) {
    switch (page) {
      case PageType.home:
        return const GButton(icon: Icons.home, text: 'Home');
      case PageType.approvals:
        return const GButton(icon: Icons.fact_check, text: 'Approvals');
      case PageType.tasks:
        return const GButton(icon: Icons.assignment, text: 'Tasks');
      case PageType.analytics:
        return const GButton(icon: Icons.analytics, text: 'Analyzer');
      case PageType.attendance:
        return const GButton(icon: Icons.calendar_month, text: 'Attendance');
      case PageType.financial:
        return const GButton(icon: Icons.account_balance_wallet, text: 'Financial');
      case PageType.management:
        return const GButton(icon: Icons.manage_accounts, text: 'Management');
      case PageType.seller:
        return const GButton(icon: Icons.store, text: 'Seller');
      case PageType.feeds:
        return const GButton(icon: Icons.rss_feed, text: 'Feeds');
      case PageType.searching:
        return const GButton(icon: Icons.search, text: 'Searching');
      case PageType.transactions:
        return const GButton(icon: Icons.receipt_long, text: 'Transaction');
      case PageType.account:
        return const GButton(icon: Icons.person, text: 'Account');
      case PageType.status:
        return const GButton(icon: Icons.info_outline, text: 'Status');
      case PageType.members:
        return const GButton(icon: Icons.group, text: 'Members');
      case PageType.activity:
        return const GButton(icon: Icons.history, text: 'Activity');
      default:
        return const GButton(icon: Icons.help, text: 'Unknown');
    }
  }).toList();
}
