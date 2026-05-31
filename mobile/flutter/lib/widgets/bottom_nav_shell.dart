import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../providers/app_state.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.child, required this.index});

  final Widget child;
  final int index;

  static const _routes = [AppRoutes.dashboard, AppRoutes.explore, AppRoutes.forum, AppRoutes.profile];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 70,
        backgroundColor: AppColors.surface.withValues(alpha: .96),
        indicatorColor: AppColors.primary.withValues(alpha: .12),
        onDestinationSelected: (value) {
          AppStateScope.of(context, listen: false).setNavIndex(value);
          if (value != index) Navigator.pushReplacementNamed(context, _routes[value]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Forum'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
