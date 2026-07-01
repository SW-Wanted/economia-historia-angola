import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/forum_topic.dart';
import '../services/backend_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/data_loader.dart';
import '../widgets/forum_topic_item.dart';
import '../widgets/screen_frame.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final Future<List<ForumTopic>> _future = BackendService.instance.forumTopics();
  String _filter = 'Todos';

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      index: 2,
      child: ScreenFrame(
        title: 'Fórum',
        showNotifications: false,
        paddingBottom: 96,
        // Elevado para não colidir com a barra de navegação flutuante.
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 84),
          child: FloatingActionButton.extended(
            heroTag: 'forum-new-topic',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createTopic),
            icon: const Icon(Icons.add),
            label: const Text('Novo tópico'),
          ),
        ),
        children: [
          _hero(context),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.searchResults),
            child: const AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar discussões',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DataLoader<List<ForumTopic>>(
            future: _future,
            builder: (context, topics) {
              final tags = ['Todos', ...{for (final t in topics) t.tag}];
              final visible = _filter == 'Todos' ? topics : topics.where((t) => t.tag == _filter).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => _filterChip(tags[i]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final topic in visible) ...[
                    ForumTopicItem(
                      topic: topic,
                      onTap: () => Navigator.pushNamed(context, topic.private ? AppRoutes.privateForumAccess : AppRoutes.forumTopic),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return ClipRRect(
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
          Positioned(right: -10, top: -12, child: Icon(Icons.forum_rounded, size: 110, color: Colors.white.withValues(alpha: .08))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debata a economia de Angola',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 19)),
                const SizedBox(height: 6),
                Text('Partilhe ideias, faça perguntas e aprenda com a comunidade.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String tag) {
    final selected = _filter == tag;
    return ChoiceChip(
      label: Text(tag),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _filter = tag),
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 12.5,
      ),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      side: BorderSide(color: selected ? AppColors.primary : AppColors.outlineVariant),
    );
  }
}
