// lib/screens/attendance/widgets/location_pin_lock_dialog.dart

import 'package:flutter/material.dart';

/// Dialog PIN Lock untuk mengamankan aksi pengambilan atau penguncian lokasi.
class LocationPinLockDialog extends StatefulWidget {
  final String expectedPin;
  final String title;
  final String subtitle;

  const LocationPinLockDialog({
    super.key,
    required this.expectedPin,
    this.title = 'Verifikasi PIN Lokasi',
    this.subtitle =
        'Masukkan PIN keamanan untuk mengambil dan mengunci koordinat lokasi.',
  });

  static Future<bool> verify(
    BuildContext context, {
    required String expectedPin,
    String title = 'Verifikasi PIN Lokasi',
    String subtitle =
        'Masukkan PIN keamanan untuk mengambil dan mengunci koordinat lokasi.',
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LocationPinLockDialog(
        expectedPin: expectedPin,
        title: title,
        subtitle: subtitle,
      ),
    );
    return result ?? false;
  }

  @override
  State<LocationPinLockDialog> createState() => _LocationPinLockDialogState();
}

class _LocationPinLockDialogState extends State<LocationPinLockDialog> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorText;
  bool _obscurePin = true;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submitPin() {
    final String entered = _pinController.text.trim();
    if (entered.isEmpty) {
      setState(() => _errorText = 'PIN tidak boleh kosong');
      return;
    }
    if (entered != widget.expectedPin) {
      setState(() {
        _errorText = 'PIN salah, silakan coba lagi';
        _pinController.clear();
      });
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.lock_outline, size: 32),
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _pinController,
            autofocus: true,
            obscureText: _obscurePin,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onSubmitted: (_) => _submitPin(),
            decoration: InputDecoration(
              labelText: 'Masukkan PIN',
              errorText: _errorText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePin ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscurePin = !_obscurePin);
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _submitPin,
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }
}