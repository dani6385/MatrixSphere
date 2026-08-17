import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';

final appBranches = appShellBranches(
  case0Screen: const HomeScreen(),
  case1Screen: const AnalyticScreen(),
  case2Screen: const ApprovalScreen(),
  case3Screen: const TransactionScreen(),
  case4Screen: const AttendanceScreen(),
);