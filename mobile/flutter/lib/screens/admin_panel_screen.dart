import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Painel Admin', showBack: true, children: [
      Text('Gestao editorial', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 18),
      _AdminTile(icon: Icons.post_add_outlined, title: 'Publicar conteudo', route: AppRoutes.publishContent),
      _AdminTile(icon: Icons.forum_outlined, title: 'Gerir forums', route: AppRoutes.manageForums),
      _AdminTile(icon: Icons.people_alt_outlined, title: 'Ver utilizadores', route: AppRoutes.adminUsers),
    ]);
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile({required this.icon, required this.title, required this.route});
  final IconData icon;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: EhCard(onTap: () => Navigator.pushNamed(context, route), child: Row(children: [Icon(icon, color: AppColors.primary), const SizedBox(width: 12), Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16))), const Icon(Icons.chevron_right)])),
      );
}
