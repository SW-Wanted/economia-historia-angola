import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/stat_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = const MockDataService().currentUser();
    return BottomNavShell(
      index: 3,
      child: ScreenFrame(
        title: 'Perfil',
        paddingBottom: 96,
        children: [
          EhCard(
            child: Column(children: [
              const CircleAvatar(radius: 40, backgroundColor: AppColors.primary,
                  child: Text('MK', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
              const SizedBox(height: 12),
              Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 2),
              Text('${user.role.label} • ${user.course}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: const [
            Expanded(child: StatTile(icon: Icons.bolt, value: '980', label: 'Pontos')),
            SizedBox(width: 12),
            Expanded(child: StatTile(icon: Icons.menu_book, value: '12', label: 'Leituras', color: AppColors.navy)),
            SizedBox(width: 12),
            Expanded(child: StatTile(icon: Icons.forum, value: '4', label: 'Topicos', color: AppColors.success)),
          ]),
          const SizedBox(height: 20),
          _tile(context, Icons.edit_outlined, 'Editar perfil', AppRoutes.editProfile),
          _tile(context, Icons.library_books_outlined, 'Minha biblioteca', AppRoutes.library),
          _tile(context, Icons.groups_outlined, 'Comunidade', AppRoutes.community),
          _tile(context, Icons.emoji_events_outlined, 'Ranking', AppRoutes.ranking),
          _tile(context, Icons.download_for_offline_outlined, 'Modo offline', AppRoutes.offlineMode),
          if (user.isAdmin)
            _tile(context, Icons.admin_panel_settings_outlined, 'Painel Admin', AppRoutes.adminPanel),
          _tile(context, Icons.feedback_outlined, 'Comentarios e sugestoes', AppRoutes.feedback),
          _tile(context, Icons.help_outline, 'Central de ajuda', AppRoutes.helpCenter),
          const SizedBox(height: 8),
          _tile(context, Icons.logout, 'Terminar sessao', AppRoutes.login, danger: true),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String route, {bool danger = false}) {
    final color = danger ? AppColors.error : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: EhCard(
        onTap: () => danger
            ? Navigator.pushNamedAndRemoveUntil(context, route, (r) => false)
            : Navigator.pushNamed(context, route),
        child: Row(children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: TextStyle(color: danger ? AppColors.error : null))),
          if (!danger) const Icon(Icons.chevron_right, color: AppColors.outline),
        ]),
      ),
    );
  }
}
