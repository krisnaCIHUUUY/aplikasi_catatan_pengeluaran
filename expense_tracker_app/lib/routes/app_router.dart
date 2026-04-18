import 'package:expense_tracker_app/screens/add_expense_page.dart';
import 'package:expense_tracker_app/screens/home_page.dart';
import 'package:expense_tracker_app/screens/home_screen.dart';
import 'package:expense_tracker_app/screens/setting_page.dart';
import 'package:expense_tracker_app/screens/statistic_screen.dart';

import 'package:go_router/go_router.dart';

part '../models/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomePage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: AppRoutes.homeName,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.transaction,
              name: AppRoutes.transactionName,
              builder: (context, state) => const StatisticScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.add,
      name: AppRoutes.addName,
      builder: (context, state) => AddExpensePage(),
    ),

    GoRoute(
      path: AppRoutes.setting,
      name: AppRoutes.settingName,
      builder: (context, state) => const SettingPage(),
    ),
  ],
);
