
// Helper untuk menentukan menu navbar berdasarkan tipe aplikasi
import 'app_type.dart';
import 'page_type.dart';

List<PageType> getNavbarItems(AppType appType) {
  switch (appType) {
    case AppType.matrixSphere:
      return [PageType.home, PageType.approvals, PageType.tasks, PageType.analytics, PageType.attendance];
    case AppType.sellerSphere:
      return [PageType.home, PageType.financial, PageType.management, PageType.seller, PageType.attendance];
    case AppType.shopSphere:
      return [PageType.home, PageType.feeds, PageType.searching, PageType.transactions, PageType.account];
    case AppType.clientConnectivity:
      return [PageType.home, PageType.status, PageType.tasks, PageType.transactions, PageType.account];
    case AppType.adminMikrotik:
      return [PageType.home, PageType.members, PageType.activity, PageType.analytics, PageType.account];
  }
}