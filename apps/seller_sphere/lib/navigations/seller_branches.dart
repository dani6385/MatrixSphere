import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';

final sellerBranches = appShellBranches(
  case0Screen: const HomeScreen(),
  case1Screen: const FinancialScreen(),
  case2Screen: const ManagementScreen(),
  case3Screen: const SellersScreen(),
  case4Screen: const AttendanceScreen(),
);