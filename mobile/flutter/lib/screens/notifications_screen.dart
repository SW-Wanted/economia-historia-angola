import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/notification_item.dart';
import '../services/mock_data_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/notification_tile.dart';
import '../widgets/screen_frame.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _cleared = false;

  @override
  Widget build(BuildContext context) {
    final items = _cleared ? const <NotificationItem>[] : const MockDataService().notifications();
    return ScreenFrame(
      title: 'Notificacoes',
      showBack: true,
      children: [
        if (items.isEmpty)
          const EmptyState(
            icon: Icons.notifications_off_outlined,
            title: 'Sem notificacoes',
            message: 'Quando houver novidades de quizzes, forum ou conteudos, aparecem aqui.',
          )
        else ...[
          Row(children: [
            Text('Recentes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _cleared = true),
              child: const Text('Marcar todas', style: TextStyle(color: AppColors.primary)),
            ),
          ]),
          const SizedBox(height: 8),
          for (final n in items) ...[NotificationTile(item: n), const SizedBox(height: 10)],
        ],
      ],
    );
  }
}
