import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      index: 3,
      child: ScreenFrame(title: 'Perfil', paddingBottom: 96, children: [
        EhCard(child: Column(children: [
          const CircleAvatar(radius: 40, backgroundColor: AppColors.primary, child: Text('MK', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
          const SizedBox(height: 12),
          Text('Manuel Kiala', style: Theme.of(context).textTheme.headlineMedium),
          const Text('Leitor Jindungo • Luanda'),
        ])),
        const SizedBox(height: 16),
        _ProfileTile(icon: Icons.edit_outlined, title: 'Editar perfil', route: AppRoutes.editProfile),
        _ProfileTile(icon: Icons.library_books_outlined, title: 'Minha biblioteca', route: AppRoutes.library),
        _ProfileTile(icon: Icons.download_for_offline_outlined, title: 'Modo offline', route: AppRoutes.offlineMode),
        _ProfileTile(icon: Icons.admin_panel_settings_outlined, title: 'Painel Admin', route: AppRoutes.adminPanel),
        _ProfileTile(icon: Icons.help_outline, title: 'Central de ajuda', route: AppRoutes.helpCenter),
      ]),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.title, required this.route});
  final IconData icon;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: EhCard(
          onTap: () => Navigator.pushNamed(context, route),
          child: Row(children: [Icon(icon, color: AppColors.primary), const SizedBox(width: 12), Expanded(child: Text(title)), const Icon(Icons.chevron_right)]),
        ),
      );
}
