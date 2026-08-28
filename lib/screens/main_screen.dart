import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../navigations/app_navigation.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppType currentApp;
  final PageType? initialPage;

  const MainNavigationScreen({
    super.key,
    required this.currentApp,
    this.initialPage, required extra,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;
  late List<PageType> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = getNavbarItems(widget.currentApp);
    
    // Cek apakah ada request untuk membuka halaman tertentu (seperti Settings)
    if (widget.initialPage != null && _menuItems.contains(widget.initialPage)) {
      _selectedIndex = _menuItems.indexOf(widget.initialPage!);
    } else if (widget.initialPage == PageType.settings) {
      // Jika settings tidak ada di navbar, kita tetap set index 0 atau tangani khusus
      _selectedIndex = 0; 
    } else {
      _selectedIndex = 0;
    }
  }

  // Fungsi navigasi konten
  Widget _buildBody(PageType pageType) {
    // Jika sedang di mode settings (khusus dari AppNavigation)
    if (widget.initialPage == PageType.settings && _selectedIndex == 0) {
       return Center(child: Text("Halaman Settings ${widget.currentApp.name}"));
    }

    switch (pageType) {
      case PageType.home: return const Center(child: Text("Home"));
      case PageType.attendance: return const Center(child: Text("Attendance"));
      case PageType.settings: return const Center(child: Text("Settings"));
      // Tambahkan case lainnya sesuai PageType...
      default: return Center(child: Text("Page: ${pageType.name}"));
    }
  }

  BottomNavigationBarItem _buildNavbarItem(PageType type) {
    IconData icon = Icons.circle;
    switch (type) {
      case PageType.home: icon = Icons.home; break;
      case PageType.attendance: icon = Icons.calendar_month; break;
      case PageType.account: icon = Icons.person; break;
      default: icon = Icons.apps;
    }
    return BottomNavigationBarItem(icon: Icon(icon), label: type.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentApp.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => AppNavigation.goToSetting(context, widget.currentApp),
          )
        ],
      ),
      body: _buildBody(_menuItems[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: _menuItems.map((type) => _buildNavbarItem(type)).toList(),
      ),
    );
  }
}