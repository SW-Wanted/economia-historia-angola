import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/community_category.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/forum_topic_item.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Detalhe de uma comunidade: cabeçalho, ação de criar tópico e lista de
/// tópicos da comunidade.
class CommunityDetailScreen extends StatelessWidget {
  const CommunityDetailScreen({super.key, this.community});

  final CommunityCategory? community;

  @override
  Widget build(BuildContext context) {
    final name = community?.name ?? 'Comunidade';
    final description = community?.description ?? 'Debates e tópicos da comunidade.';
    final topics = const MockDataService().topics().where((t) => !t.private).take(4).toList();

    return ScreenFrame(
      title: name,
      showBack: true,
      children: [
        // Cabeçalho da comunidade.
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.navy, Color(0xFF002336)],
                    ),
                  ),
                ),
              ),
              Positioned(right: -10, top: -12, child: Icon(Icons.groups_rounded, size: 110, color: Colors.white.withValues(alpha: .08))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.4)),
                    if (community != null) ...[
                      const SizedBox(height: 12),
                      Text('${community!.topics} tópicos • ${community!.members} membros',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        EhButton(
          label: 'Criar tópico',
          icon: Icons.add,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createTopic),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Tópicos da comunidade'),
        const SizedBox(height: 12),
        for (final topic in topics) ...[
          ForumTopicItem(topic: topic, onTap: () => Navigator.pushNamed(context, AppRoutes.forumTopic)),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
