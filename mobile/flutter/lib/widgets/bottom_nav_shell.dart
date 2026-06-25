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
    // NOTA: o [child] (ScreenFrame) já é um Scaffold. Para evitar dois
    // Scaffolds aninhados — que em web colapsam a altura do corpo e deixam
    // o ecrã em branco —, a barra de navegação é colocada por baixo do filho
    // num único Scaffold exterior, deixando o corpo do filho ocupar o espaço.
    final navBar = NavigationBar(
      selectedIndex: index,
      height: 70,
      backgroundColor: AppColors.surface.withValues(alpha: .96),
      indicatorColor: AppColors.primary.withValues(alpha: .12),
      onDestinationSelected: (value) {
        AppStateScope.of(context, listen: false).setNavIndex(value);
        if (value != index) Navigator.pushReplacementNamed(context, _routes[value]);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
        NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explorar'),
        NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Fórum'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
      ],
    );

    return Scaffold(
      body: child,
      bottomNavigationBar: navBar,
    );
  }
}
