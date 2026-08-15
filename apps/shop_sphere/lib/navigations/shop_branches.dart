import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';

final shopBranches = buildSharedShellBranches(
  case0Screen: const HomeScreen(),
  case1Screen: const FeedScreen(),
  case2Screen: const SearchingScreen(),
  case3Screen: const TransactionScreen(),
  case4Screen: const AccountScreen(),
);