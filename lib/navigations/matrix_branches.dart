import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';

final matrixBranches = buildSharedShellBranches(
  homeScreen: const HomeScreen(),
  approvalsScreen: const ApprovalScreen(),
  analyticsScreen: const AnalyticScreen(),
  transactionsScreen: const TransactionsScreen(),
  attendanceScreen: const AttendanceScreen(),
);