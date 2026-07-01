import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../services/backend_service.dart';
import '../widgets/admin_action_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_tile.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    return ScreenFrame(
      title: 'Painel de Administração',
      showBack: true,
      children: [
        Text('Olá, ${user.name.split(' ').first}', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
        Text('Perfil: ${user.role.label}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 20),
        Row(children: const [
          Expanded(child: StatTile(icon: Icons.menu_book_outlined, value: '32', label: 'Conteúdos')),
          SizedBox(width: 12),
          Expanded(child: StatTile(icon: Icons.people_outline, value: '268', label: 'Utilizadores', color: AppColors.navy)),
          SizedBox(width: 12),
          Expanded(child: StatTile(icon: Icons.flag_outlined, value: '3', label: 'Denúncias', color: AppColors.error)),
        ]),
        const SizedBox(height: 24),
        const SectionTitle('Gestão editorial'),
        const SizedBox(height: 12),
        AdminActionCard(icon: Icons.post_add_outlined, title: 'Publicar conteúdo', subtitle: 'Artigos, vídeos, podcasts e Jindungo.', onTap: () => Navigator.pushNamed(context, AppRoutes.publishContent)),
        const SizedBox(height: 10),
        AdminActionCard(icon: Icons.fact_check_outlined, title: 'Aprovação de conteúdos', subtitle: 'Rever submissões dos escritores.', onTap: () => Navigator.pushNamed(context, AppRoutes.contentModeration)),
        const SizedBox(height: 10),
        AdminActionCard(icon: Icons.forum_outlined, title: 'Gerir fóruns', subtitle: 'Tópicos, pedidos e moderação.', onTap: () => Navigator.pushNamed(context, AppRoutes.manageForums)),
        const SizedBox(height: 24),
        const SectionTitle('Comunidade e acesso'),
        const SizedBox(height: 12),
        AdminActionCard(icon: Icons.people_alt_outlined, title: 'Gestão de utilizadores', subtitle: 'Ver e editar perfis.', onTap: () => Navigator.pushNamed(context, AppRoutes.adminUsers)),
        const SizedBox(height: 10),
        if (user.role == UserRole.superAdmin) ...[
          AdminActionCard(icon: Icons.shield_outlined, title: 'Permissões (Super Admin)', subtitle: 'Definir papéis e acessos.', onTap: () => Navigator.pushNamed(context, AppRoutes.adminUsers)),
          const SizedBox(height: 10),
          AdminActionCard(icon: Icons.account_tree_outlined, title: 'Cadeia de Super Admins', subtitle: 'Hierarquia e sucessão por grau.', onTap: () => Navigator.pushNamed(context, AppRoutes.superAdminChain)),
          const SizedBox(height: 10),
        ],
        AdminActionCard(icon: Icons.report_gmailerrorred_outlined, title: 'Denúncias pendentes', subtitle: 'Rever conteúdo reportado.', onTap: () => Navigator.pushNamed(context, AppRoutes.pendingReports)),
      ],
    );
  }
}
