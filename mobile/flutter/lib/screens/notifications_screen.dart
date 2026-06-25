import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/notification_item.dart';
import '../services/backend_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/notification_tile.dart';
import '../widgets/screen_frame.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem>? _items; // null enquanto carrega

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await BackendService.instance.notifications();
    if (!mounted) return;
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items == null) {
      return const ScreenFrame(
        title: 'Notificações',
        showBack: true,
        children: [
          Padding(padding: EdgeInsets.only(top: 80), child: Center(child: CircularProgressIndicator())),
        ],
      );
    }
    return ScreenFrame(
      title: 'Notificações',
      showBack: true,
      children: [
        if (items.isEmpty)
          const EmptyState(
            icon: Icons.notifications_off_outlined,
            title: 'Sem notificações',
            message: 'Quando houver novidades de quizzes, fórum ou conteúdos, aparecem aqui.',
          )
        else ...[
          Row(children: [
            Text('Recentes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _items = const <NotificationItem>[]),
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
