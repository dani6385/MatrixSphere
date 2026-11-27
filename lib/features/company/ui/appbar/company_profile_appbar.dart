import 'package:flutter/material.dart';

import '../../config/company_config.dart';

class CompanyProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isAdmin;
  final VoidCallback onEditPressed;

  const CompanyProfileAppBar({
    super.key,
    required this.isAdmin,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(CompanyConfig.screenTitle),
      actions: [
        if (isAdmin)
          IconButton(
            tooltip: CompanyConfig.editTooltip,
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEditPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}