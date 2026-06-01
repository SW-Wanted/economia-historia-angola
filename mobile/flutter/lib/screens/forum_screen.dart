import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/forum_topic_item.dart';
import '../widgets/screen_frame.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = const MockDataService().topics();
    return BottomNavShell(
      index: 2,
      child: ScreenFrame(
        title: 'Forum',
        paddingBottom: 96,
        floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.createTopic), child: const Icon(Icons.add)),
        children: [
          const TextField(decoration: InputDecoration(hintText: 'Pesquisar discussoes', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 18),
          for (final topic in topics) ...[
            ForumTopicItem(topic: topic, onTap: () => Navigator.pushNamed(context, topic.private ? AppRoutes.privateForumAccess : AppRoutes.forumTopic)),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
