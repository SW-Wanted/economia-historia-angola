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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 1.0)),
        ),
        child: NavigationBar(
          selectedIndex: index,
          height: 64,
          backgroundColor: AppColors.surface,
          elevation: 0,
          indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (value) {
            AppStateScope.of(context, listen: false).setNavIndex(value);
            if (value != index) Navigator.pushReplacementNamed(context, _routes[value]);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppColors.primary), label: 'Início'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore, color: AppColors.primary), label: 'Explorar'),
            NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum, color: AppColors.primary), label: 'Fórum'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: AppColors.primary), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
