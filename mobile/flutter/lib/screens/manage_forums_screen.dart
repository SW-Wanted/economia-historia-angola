import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../widgets/forum_topic_item.dart';
import '../widgets/screen_frame.dart';

class ManageForumsScreen extends StatelessWidget {
  const ManageForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = const MockDataService().topics();
    return ScreenFrame(title: 'Gerir forums', showBack: true, children: [
      for (final topic in topics) ...[ForumTopicItem(topic: topic), const SizedBox(height: 12)],
    ]);
  }
}
