import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      index: 2,
      child: ScreenFrame(
        title: 'Fórum',
        showNotifications: false,
        paddingBottom: 96,
        floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.createTopic), child: const Icon(Icons.add)),
        children: [
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
          const SizedBox(height: 18),
          DataLoader<List<ForumTopic>>(
            future: _future,
            builder: (context, topics) => Column(
              children: [
                for (final topic in topics) ...[
                  ForumTopicItem(topic: topic, onTap: () => Navigator.pushNamed(context, topic.private ? AppRoutes.privateForumAccess : AppRoutes.forumTopic)),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
