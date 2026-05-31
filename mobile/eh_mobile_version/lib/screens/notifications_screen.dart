import 'package:flutter/material.dart';

import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = ['Novo quiz semanal disponivel', 'Ana respondeu ao seu topico', 'Texto Jindungo publicado'];
    return ScreenFrame(title: 'Notificacoes', showBack: true, children: [
      for (final item in items) ...[
        EhCard(child: Row(children: [const Icon(Icons.notifications_none), const SizedBox(width: 12), Expanded(child: Text(item))])),
        const SizedBox(height: 10),
      ],
    ]);
  }
}
