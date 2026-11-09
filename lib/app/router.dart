import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/onboarding_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/progress/presentation/progress_screen.dart';
import '../features/settings/application/settings_controller.dart';
import '../features/settings/presentation/about_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/workout/presentation/screens/active_workout_screen.dart';
import '../features/workout/presentation/screens/session_detail_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Created once; onboarding status only picks the initial location so the
/// router is never rebuilt (which would reset navigation).
final routerProvider = Provider<GoRouter>((ref) {
  final onboarded = ref.read(settingsControllerProvider).onboardingCompleted;
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: onboarded ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _Shell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (_, _) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/workout',
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: ActiveWorkoutScreen(),
        ),
      ),
      GoRoute(
        path: '/session/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => SessionDetailScreen(
          sessionId: state.pathParameters['id']!,
          justCompleted: state.uri.queryParameters['completed'] == '1',
        ),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/about',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const AboutScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class _Shell extends StatelessWidget {
  const _Shell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (i) =>
          shell.goBranch(i, initialLocation: i == shell.currentIndex),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_outlined),
          selectedIcon: Icon(Icons.insights_rounded),
          label: 'Progress',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    ),
  );
}
