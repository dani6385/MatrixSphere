import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/app_navigator_drawer.dart';
import 'widgets/app_navigator_end_drawer.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  // Fungsi untuk memberitahu GoRouter agar berpindah branch/tab
  /*void _onItemTapped(int index) {
    // Akses navigationShell melalui 'widget'
    widget.navigationShell.goBranch(index);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // Akses navigationShell melalui 'widget' untuk menampilkannya di body
      body: widget.navigationShell,
      drawer: const AppNavigatorDrawer(),
      endDrawer: const AppNavigatorEndDrawer(),
      // Anda bisa menambahkan BottomNavigationBar di sini jika diperlukan di masa mendatang
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     // ... item Anda ...
      //   ],
      //   currentIndex: widget.navigationShell.currentIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
