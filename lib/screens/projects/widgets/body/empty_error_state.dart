import 'package:flutter/material.dart';

class EmptyErrorState extends StatelessWidget {
  final String message;
  final bool showIcon;

  const EmptyErrorState({
    super.key,
    required this.message,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[
            const Icon(Icons.verified_user, size: 64, color: Colors.green),
            const SizedBox(height: 12),
          ],
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}