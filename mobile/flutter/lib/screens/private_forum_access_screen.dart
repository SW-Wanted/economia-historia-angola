import 'package:flutter/material.dart';

import '../widgets/eh_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/screen_frame.dart';

class PrivateForumAccessScreen extends StatelessWidget {
  const PrivateForumAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Forum privado', showBack: true, children: [
      const EmptyState(icon: Icons.lock_outline, title: 'Acesso reservado', message: 'Este debate e exclusivo para membros Jindungo.'),
      const SizedBox(height: 20),
      EhButton(label: 'Gerir subscricao', onPressed: () {}),
    ]);
  }
}
