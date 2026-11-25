import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_extractor.dart';

final List<StatefulShellBranch> appBranches = <StatefulShellBranch>[
  // Branch 0: Beranda / Home (rute default di dalam shell)
  StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  ),

  // Branch 1: Persetujuan / Systems
  StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.system,
        name: 'Systems',
        builder: (context, state) => const SystemScreen(),
      ),
    ],
  ),

  // Branch 2: Analitik / Analytics
  StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.analytics,
        name: 'analytics',
        builder: (context, state) => const AnalyticScreen(),
      ),
    ],
  ),

  // Branch 3: Transaksi & Proyek / Transactions
  StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.transactions,
        name: 'transactions',
        builder: (context, state) => const ProjectScreen(),
      ),
    ],
  ),

  // Branch 4: Kehadiran / Attendance
  StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.attendance,
        name: 'attendance',
        builder: (context, state) => const AttendanceScreen(),
      ),
    ],
  ),
];