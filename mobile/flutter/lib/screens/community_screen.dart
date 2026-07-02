import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Comunidade — categorias públicas e privadas + atalho para fóruns.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = const MockDataService().categories();
    return ScreenFrame(
      title: 'Comunidade',
      showBack: true,
      children: [
        EhCard(
          color: AppColors.primary,
          onTap: () => Navigator.pushNamed(context, AppRoutes.forum),
          child: Row(
            children: [
              const Icon(Icons.forum, color: Colors.white, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fórum de Debate', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('Debates abertos sobre economia e história.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionTitle('Comunidades', action: TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createCommunity),
          icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
          label: const Text('Criar', style: TextStyle(color: AppColors.primary)),
        )),
        const SizedBox(height: 12),
        for (final cat in categories) ...[
          EhCard(
            onTap: () => cat.private
                ? Navigator.pushNamed(context, AppRoutes.privateForumAccess)
                : Navigator.pushNamed(context, AppRoutes.communityDetail, arguments: cat),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: cat.private ? AppColors.navy.withValues(alpha: .1) : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(cat.private ? Icons.lock_outline : Icons.tag,
                      color: cat.private ? AppColors.navy : AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(cat.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16))),
                          if (cat.private) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(6)),
                              child: Text('PRIVADA', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 10)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(cat.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      Text('${cat.topics} tópicos • ${cat.members} membros',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
