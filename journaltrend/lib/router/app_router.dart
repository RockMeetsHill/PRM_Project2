// router/app_router.dart
// Purpose: Configures GoRouter containing a ShellRoute with BottomNavigationBar for main tabs (Search, Trends, Dashboard) and a detail route for publications.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/publication.dart';
import '../screens/search_screen.dart';
import '../screens/trend_analysis_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/publication_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/search',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path: '/trends',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TrendAnalysisScreen(),
          ),
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/publication/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final publication = state.extra as Publication;
        return PublicationDetailScreen(publication: publication);
      },
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/search')) {
      return 0;
    }
    if (location.startsWith('/trends')) {
      return 1;
    }
    if (location.startsWith('/dashboard')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/search');
        break;
      case 1:
        context.go('/trends');
        break;
      case 2:
        context.go('/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
