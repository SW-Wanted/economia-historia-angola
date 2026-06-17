import 'package:flutter/material.dart';

import '../widgets/eh_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/screen_frame.dart';

class OfflineModeScreen extends StatelessWidget {
  const OfflineModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Modo Offline', showBack: true, children: [
      const EmptyState(icon: Icons.download_for_offline_outlined, title: 'Leituras guardadas', message: 'Descarregue conteudos para estudar sem internet.'),
      const SizedBox(height: 20),
      EhButton(label: 'Sincronizar biblioteca', onPressed: () {}),
    ]);
  }
}
