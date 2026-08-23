import 'package:flutter/material.dart';

class OptionsButtons extends StatelessWidget {
  const OptionsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Atau masuk dengan', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // Logika Google Sign In di sini
          },
          icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
          label: const Text('Masuk dengan Google'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}