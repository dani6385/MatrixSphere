
import 'package:flutter/material.dart';

class WindowsMapView extends StatelessWidget {
  const WindowsMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Windows Map View'),
      ),
      body: const Center(
        child: Text('This is the Windows Map View screen.'),
      ),
    );
  }
}