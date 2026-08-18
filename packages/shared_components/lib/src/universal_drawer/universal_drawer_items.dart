import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

// Impor file-file pecahan di atas
import 'project_drawer/matrix_sphere_drawer.dart';
import 'seller_sphere_drawer.dart';
import 'admin_mikrotik_drawer.dart';
import 'client_connectivity_drawer.dart';

/// Returns a list of `SideMenuItem` for the main drawer based on the feature.
List<SideMenuItem> getUniversalDrawerItems(
  BuildContext context, {
  required AppType appType,
  required PageType pageType,
  required String currentRoute,
}) {
  switch (appType) {
    case AppType.matrixSphere:
      return MatrixSphereDrawer.getDrawerItems(context, pageType, currentRoute);
    case AppType.adminMikrotik:
      return AdminMikrotikDrawer.getDrawerItems(
          context, pageType, currentRoute);
    case AppType.clientConnectivity:
      return ClientConnectivityDrawer.getDrawerItems(
          context, pageType, currentRoute);
    case AppType.sellerSphere:
      return SellerSphereDrawer.getDrawerItems(context, pageType, currentRoute);
    case AppType.shopSphere:
      // Bisa dibuatkan file shop_sphere_drawer.dart terpisah juga
      return [];
  }
}

/// Returns a list of `SideMenuItem` for the end drawer (settings).
List<SideMenuItem> getUniversalEndDrawerItems(
  BuildContext context, {
  required AppType appType,
  required PageType pageType,
}) {
  switch (appType) {
    case AppType.matrixSphere:
      return MatrixSphereDrawer.getEndDrawerItems(context, pageType);
    case AppType.sellerSphere:
      return SellerSphereDrawer.getEndDrawerItems(context, pageType);
    case AppType.adminMikrotik:
      return AdminMikrotikDrawer.getEndDrawerItems(context, pageType);
    case AppType.clientConnectivity:
      return ClientConnectivityDrawer.getEndDrawerItems(context, pageType);
    case AppType.shopSphere:
      return SellerSphereDrawer.getEndDrawerItems(context, pageType);
  }
}
