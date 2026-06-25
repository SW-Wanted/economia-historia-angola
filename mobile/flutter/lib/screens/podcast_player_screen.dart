import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/screen_frame.dart';

/// Leitor de podcast (offline-friendly: o áudio real seria descarregável).
class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({super.key});

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  bool _playing = false;
  double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Podcast',
      showBack: true,
      children: [
        EhIllustration(scene: EhScene.podcast, height: 200, borderRadius: BorderRadius.circular(24)),
        const SizedBox(height: 24),
        Text('Conversas de Economia', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text('O Petróleo e o Futuro de Angola', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('Episódio 4 • com Dr. Kambinda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 24),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.outlineVariant,
            thumbColor: AppColors.primary,
            trackHeight: 4,
          ),
          child: Slider(value: _progress, onChanged: (v) => setState(() => _progress = v)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(_progress * 28).toStringAsFixed(0)}:00', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              Text('28:00', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(tooltip: 'Recuar 10 segundos', iconSize: 34, onPressed: () {}, icon: const Icon(Icons.replay_10, color: AppColors.primary)),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => setState(() => _playing = !_playing),
              child: Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Icon(_playing ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 38),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(tooltip: 'Avançar 30 segundos', iconSize: 34, onPressed: () {}, icon: const Icon(Icons.forward_30, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Episódio disponível offline'), behavior: SnackBarBehavior.floating)),
          icon: const Icon(Icons.download_outlined),
          label: const Text('Descarregar para ouvir offline'),
          style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), minimumSize: const Size.fromHeight(50)),
        ),
        const SizedBox(height: 24),
        Text('Sobre o episódio', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          'Uma conversa sobre a dependência do petróleo na economia angolana e os '
          'caminhos para a diversificação, ligando história e presente.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.5),
        ),
      ],
    );
  }
}
