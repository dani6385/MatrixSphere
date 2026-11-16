import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/projects/models/app_error_model.dart';

class ErrorLogCard extends StatelessWidget {
  final AppErrorModel error;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ErrorLogCard({
    super.key,
    required this.error,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: error.isResolved ? Colors.green.shade200 : Colors.red.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: error.isResolved ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(
            error.isResolved ? Icons.check : Icons.warning_amber_rounded,
            color: error.isResolved ? Colors.green : Colors.red,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: error.badgeColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                error.appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error.timestamp,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              error.errorMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'HP: ${error.deviceInfo} • User: ${error.userEmail}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          tooltip: 'Hapus Log',
          onPressed: onDelete,
        ),
      ),
    );
  }
}