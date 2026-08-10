
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home/components/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      drawer: const HomeDrawer(),
      body: const Center(
        child: Text('Welcome to Seller Sphere!'),
      ),
    );
  }
}