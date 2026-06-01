import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Player de Video', showBack: true, children: [
      EhCard(
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(alignment: Alignment.center, children: [
            Icon(Icons.history_edu, color: Colors.white.withValues(alpha: .16), size: 92),
            const CircleAvatar(radius: 34, backgroundColor: AppColors.primary, child: Icon(Icons.play_arrow, color: Colors.white, size: 42)),
          ]),
        ),
      ),
      const SizedBox(height: 18),
      Text('A historia do Caminho de Ferro de Benguela', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      const Text('Aula visual com marcadores, transcricao e progresso guardado.'),
    ]);
  }
}
