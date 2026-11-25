
import 'package:flutter/material.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Screen'),
      ),
      body: const Center(
        child: Text('System Screen Content'),
      ),
    );
  }
}