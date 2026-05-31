import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../widgets/ranking_item.dart';
import '../widgets/screen_frame.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = const MockDataService().ranking();
    return ScreenFrame(title: 'Utilizadores', showBack: true, children: [
      for (var i = 0; i < users.length; i++) ...[RankingItem(user: users[i], position: i + 1), const SizedBox(height: 10)],
    ]);
  }
}
