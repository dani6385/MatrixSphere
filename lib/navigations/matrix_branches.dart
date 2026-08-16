import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';

/*final authBranches = authShellBranches(
  loginScreen: const LoginScreen(),
  forgotScreen:  const ForgotScreen(),
  regitrationScreen: const RegisterScreen(),
);*/
final bottomBranches = bottomShellBranches(
  case0Screen: const HomeScreen(),
  case1Screen: const ApprovalScreen(),
  case2Screen: const AnalyticScreen(),
  case3Screen: const TransactionScreen(),
  case4Screen: const AttendanceScreen(),
);

