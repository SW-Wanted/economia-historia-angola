import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/admin_action_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Painel de Gestão — reúne as métricas de impacto das publicações e o acesso à
/// administração da plataforma (consoante os privilégios). A gestão de conteúdos
/// é uma funcionalidade à parte ("Os Meus Conteúdos"), pelo que não aparece aqui.
class ManagementPanelScreen extends StatelessWidget {
  const ManagementPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    final fs = FeedService.instance;

    final content = fs.catalog
        .where((c) => c.type == FeedContentType.article || c.type == FeedContentType.video || c.type == FeedContentType.podcast)
        .toList();
    int sum(int Function(FeedContent) f) => content.fold(0, (a, c) => a + f(c));

    return ScreenFrame(
      title: 'Painel de Gestão',
      showBack: true,
      showNotifications: false,
      children: [
        if (user.canPublish) ...[
          const SectionTitle('Impacto das publicações'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              _metric(context, Icons.visibility_outlined, formatCount(sum((c) => c.views)), 'Visualizações'),
              _metric(context, Icons.favorite_border, formatCount(sum((c) => c.likes)), 'Gostos'),
              _metric(context, Icons.mode_comment_outlined, formatCount(sum((c) => c.comments)), 'Comentários'),
              _metric(context, Icons.ios_share, formatCount(sum((c) => c.shares)), 'Partilhas'),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (user.canModerate) ...[
          const SectionTitle('Administração'),
          const SizedBox(height: 12),
          // "Painel de administração" mantém o seu símbolo habitual.
          AdminActionCard(
            icon: Icons.dashboard_customize_outlined,
            title: 'Painel de administração',
            subtitle: 'Utilizadores, conteúdos, denúncias e moderação.',
            onTap: () => Navigator.pushNamed(context, AppRoutes.adminPanel),
          ),
        ],
      ],
    );
  }

  Widget _metric(BuildContext context, IconData icon, String value, String label) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .10), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
            ]),
          ),
        ]),
      );
}
