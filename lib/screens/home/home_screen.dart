
import 'package:flutter/material.dart';
import 'package:shared_components/shared_components.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      drawer: DrawerFactory.createDrawer(
        context,
        appType: AppType.matrixSphere,
        pageType: PageType.home,
      ),
      endDrawer: DrawerFactory.createEndDrawer(context,
          appType: AppType.matrixSphere,
          pageType: PageType.home),
      body: const Center(
        child: Text('Apaka sekarang benar saya ingin tahu hasilnya'),
      ),
    );
  }
}