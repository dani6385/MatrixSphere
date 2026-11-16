import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix_sphere/screens/projects/models/app_error_model.dart';

class ErrorDetailDialog extends StatelessWidget {
  final AppErrorModel error;
  final VoidCallback onMarkResolved;

  const ErrorDetailDialog({
    super.key,
    required this.error,
    required this.onMarkResolved,
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.bug_report, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Detail Error: ${error.appName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Aplikasi', '${error.appName} (v${error.appVersion})'),
              _buildInfoRow('Waktu', error.timestamp),
              _buildInfoRow('Pengguna', error.userEmail),
              _buildInfoRow('Perangkat HP', error.deviceInfo),
              _buildInfoRow('Konteks', error.contextInfo),
              const Divider(height: 20),
              const Text(
                'Pesan Error:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SelectableText(
                  error.errorMessage,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stack Trace (Jejak Kode):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Salin'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: error.stackTrace));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Stack trace disalin ke clipboard!')),
                      );
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 180,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    error.stackTrace,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (!error.isResolved)
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Tandai Selesai'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onMarkResolved();
            },
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}