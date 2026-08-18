import 'package:flutter/material.dart';

/// A reusable header widget for drawers.
///
/// This widget displays an icon and a title within a `DrawerHeader`.
class UniversalDrawerHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;

  const UniversalDrawerHeader({
    super.key,
    required this.title,
    required this.icon,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}