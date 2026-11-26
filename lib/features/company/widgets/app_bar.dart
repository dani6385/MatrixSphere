import 'package:flutter/material.dart';

class CompanyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAdmin;
  final bool isSaving;
  final VoidCallback onSave;

  const CompanyAppBar({
    super.key,
    required this.isAdmin,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('MS Matrix Sphere'),
      actions: [
        if (isAdmin)
          IconButton(
            tooltip: 'Simpan',
            icon: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            onPressed: isSaving ? null : onSave,
          ),
      ],
    );
  }
}