import 'package:flutter/material.dart';

class SaveCompanyButton extends StatelessWidget {
  final bool enabled;
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveCompanyButton({
    super.key,
    required this.enabled,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      child: Text(isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
    );
  }
}