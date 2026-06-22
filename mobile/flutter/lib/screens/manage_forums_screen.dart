import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class ManageForumsScreen extends StatelessWidget {
  const ManageForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = const MockDataService().topics();
    return ScreenFrame(
      title: 'Gerir Forums',
      showBack: true,
      children: [
        const SectionTitle('Pedidos de acesso'),
        const SizedBox(height: 12),
        EhCard(
          child: Column(
            children: [
              for (final name in const ['Joao Domingos', 'Elisa Kiala'])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceContainer,
                          child: Text(name.split(' ').map((e) => e[0]).take(2).join(),
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13))),
                      const SizedBox(width: 12),
                      Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyLarge)),
                      IconButton(icon: const Icon(Icons.check_circle, color: AppColors.success), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.cancel, color: AppColors.error), onPressed: () {}),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Topicos'),
        const SizedBox(height: 12),
        for (final topic in topics) ...[
          EhCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.forumTopic),
            child: Row(
              children: [
                Icon(topic.private ? Icons.lock_outline : Icons.tag, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(topic.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                      Text('${topic.comments} respostas • ${topic.role}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.secondary),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'pin', child: Text('Fixar')),
                    PopupMenuItem(value: 'hide', child: Text('Ocultar')),
                    PopupMenuItem(value: 'del', child: Text('Remover')),
                  ],
                  onSelected: (_) {},
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
