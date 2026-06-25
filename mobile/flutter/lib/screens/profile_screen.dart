import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../services/backend_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    return BottomNavShell(
      index: 3,
      child: ScreenFrame(
        title: 'Perfil',
        showNotifications: false,
        paddingBottom: 96,
        children: [
          EhCard(
            child: Column(children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(user.name, style: Theme.of(context).textTheme.headlineMedium)),
                  if (user.isFounder) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.workspace_premium, size: 20, color: AppColors.warning),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              _roleChip(context, user),
              const SizedBox(height: 4),
              Text('${user.course} • ${user.institution}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: StatTile(icon: Icons.bolt, value: '${user.points}', label: 'Pontos')),
            const SizedBox(width: 12),
            const Expanded(child: StatTile(icon: Icons.menu_book, value: '12', label: 'Leituras', color: AppColors.navy)),
            const SizedBox(width: 12),
            const Expanded(child: StatTile(icon: Icons.forum, value: '4', label: 'Tópicos', color: AppColors.success)),
          ]),
          const SizedBox(height: 24),

          // ---- O que este perfil pode fazer (apenas o seu próprio nível) ----
          SectionTitle('O que pode fazer como ${user.role.label}'),
          const SizedBox(height: 12),
          EhCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final p in user.role.permissions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 18, color: AppColors.success),
                        const SizedBox(width: 10),
                        Expanded(child: Text(p, style: Theme.of(context).textTheme.bodyMedium)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SectionTitle('Conta'),
          const SizedBox(height: 12),
          _tile(context, Icons.edit_outlined, 'Editar perfil', AppRoutes.editProfile),
          _tile(context, Icons.library_books_outlined, 'Minha biblioteca', AppRoutes.library),
          _tile(context, Icons.groups_outlined, 'Comunidade', AppRoutes.community),
          _tile(context, Icons.emoji_events_outlined, 'Ranking', AppRoutes.ranking),
          _tile(context, Icons.download_for_offline_outlined, 'Modo offline', AppRoutes.offlineMode),
          _tile(context, Icons.card_membership_outlined, 'Subscrição', AppRoutes.subscription),

          // ---- Secção exclusiva de gestão (escritor+/admin) ----
          if (user.canPublish || user.canModerate) ...[
            const SizedBox(height: 24),
            SectionTitle('Criação e gestão'),
            const SizedBox(height: 12),
            if (user.canPublish)
              _tile(context, Icons.post_add_outlined, 'Publicar conteúdo', AppRoutes.publishContent),
            if (user.canModerate) ...[
              _tile(context, Icons.admin_panel_settings_outlined, 'Painel de administração', AppRoutes.adminPanel),
              _tile(context, Icons.people_outline, 'Gestão de utilizadores', AppRoutes.adminUsers),
            ],
          ],

          const SizedBox(height: 24),
          SectionTitle('Apoio'),
          const SizedBox(height: 12),
          _tile(context, Icons.feedback_outlined, 'Comentários e sugestões', AppRoutes.feedback),
          _tile(context, Icons.help_outline, 'Central de ajuda', AppRoutes.helpCenter),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: EhCard(
              onTap: () => _logout(context),
              child: const Row(children: [
                Icon(Icons.logout, color: AppColors.error),
                SizedBox(width: 14),
                Expanded(child: Text('Terminar sessão', style: TextStyle(color: AppColors.error))),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await BackendService.instance.logout();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
  }

  Widget _roleChip(BuildContext context, AppUser user) {
    final label = user.isSuperAdmin ? 'Super Admin · grau ${user.superAdminGrade}' : user.role.label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
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
