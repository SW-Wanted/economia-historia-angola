import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/notification_item.dart';
import '../services/backend_service.dart';
import '../services/realtime_service.dart';
import '../widgets/app_loading_indicator.dart';
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
  StreamSubscription<NotificationItem>? _liveSub;

  @override
  void initState() {
    super.initState();
    _load();
    // Garante a ligação realtime e adiciona novas notificações ao topo assim que
    // chegam (push do backend), sem o utilizador precisar de recarregar.
    RealtimeService.instance.connect();
    _liveSub = RealtimeService.instance.onNotification.listen((item) {
      if (!mounted) return;
      setState(() => _items = [item, ...?_items]);
    });
  }

  @override
  void dispose() {
    _liveSub?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final items = await BackendService.instance.notifications();
    if (!mounted) return;
    setState(() => _items = items);
  }

  Future<void> _markAllRead() async {
    final current = _items;
    if (current == null || current.every((n) => !n.unread)) return;
    // Otimista: marca localmente e persiste no backend.
    setState(() => _items = [for (final n in current) n.copyWith(unread: false)]);
    try {
      await BackendService.instance.markAllNotificationsRead();
    } catch (_) {
      // Falha de rede — recarrega para refletir o estado real do servidor.
      await _load();
    }
  }

  Future<void> _markOneRead(NotificationItem item) async {
    if (!item.unread) return;
    final current = _items;
    if (current == null) return;
    setState(() => _items = [for (final n in current) identical(n, item) ? n.copyWith(unread: false) : n]);
    try {
      await BackendService.instance.markNotificationRead(item.id);
    } catch (_) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items == null) {
      return const ScreenFrame(
        title: 'Notificações',
        showBack: true,
        children: [
          Padding(padding: EdgeInsets.only(top: 60), child: Center(child: AppLoadingIndicator(message: 'A carregar...'))),
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
              onPressed: _markAllRead,
              child: const Text('Marcar todas', style: TextStyle(color: AppColors.primary)),
            ),
          ]),
          const SizedBox(height: 8),
          for (final n in items) ...[
            GestureDetector(
              onTap: () => _markOneRead(n),
              behavior: HitTestBehavior.opaque,
              child: NotificationTile(item: n),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}
