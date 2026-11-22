import 'package:flutter/material.dart';

/// Model data untuk setiap item yang akan ditampilkan di dalam [SideMenu].
class SideMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  final String route;
  final String label;

  const SideMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.route = '',
    this.label = '',
  });
}

/// Widget laci navigasi (drawer) yang dapat digunakan kembali di berbagai layar.
class SideMenu extends StatelessWidget {
  final Widget header;
  final List<SideMenuItem> items;
  final Widget? footer;
  final String selectedRoute;
  final List<Widget>? children;
  final void Function(SideMenuItem item)? onItemSelected;

  const SideMenu({
    super.key,
    required this.header,
    required this.items,
    this.footer,
    this.selectedRoute = '',
    this.children,
    this.onItemSelected,
  });

  void _closeDrawerIfOpen(BuildContext context) {
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen == true) {
      scaffold!.closeDrawer();
    } else if (scaffold?.isEndDrawerOpen == true) {
      scaffold!.closeEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color activeColor = theme.colorScheme.primary;
    final Color textColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final Color iconColor = theme.iconTheme.color ?? theme.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        backgroundColor: theme.drawerTheme.backgroundColor ?? theme.colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            header,
            ..._buildMenuItems(context, activeColor, textColor, iconColor),
            if (children != null) ...children!,
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(
    BuildContext context,
    Color activeColor,
    Color textColor,
    Color iconColor,
  ) {
    return items.map((item) {
      final bool itemSelected =
          item.isSelected || (selectedRoute.isNotEmpty && item.route == selectedRoute);

      return ListTile(
        leading: Icon(
          item.icon,
          color: itemSelected ? activeColor : iconColor,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: itemSelected ? activeColor : textColor,
          ),
        ),
        subtitle: item.label.isNotEmpty ? Text(item.label) : null,
        selected: itemSelected,
        selectedTileColor: activeColor.withValues(alpha: 0.1),
        onTap: () {
          _closeDrawerIfOpen(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            item.onTap();
            onItemSelected?.call(item);
          });
        },
      );
    }).toList();
  }
}