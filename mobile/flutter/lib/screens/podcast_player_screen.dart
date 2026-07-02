import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/screen_frame.dart';

/// Duração da amostra gratuita (modo prévia): 30 segundos.
const _kPreviewSeconds = 30;

/// Leitor de podcast (offline-friendly: o áudio real seria descarregável).
class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({super.key});

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  static const _totalSeconds = 28 * 60; // 28:00

  bool _preview = false;
  bool _initialized = false;
  bool _playing = false;
  bool _limitReached = false;
  int _seconds = (0.35 * _totalSeconds).round();
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // `arguments == true` → modo prévia (visitante): só os primeiros 30s.
    _preview = ModalRoute.of(context)?.settings.arguments == true;
    if (_preview) _seconds = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    if (_limitReached) return;
    setState(() => _playing = !_playing);
    if (_playing) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    } else {
      _timer?.cancel();
    }
  }

  void _tick() {
    final cap = _preview ? _kPreviewSeconds : _totalSeconds;
    setState(() {
      _seconds++;
      if (_seconds >= cap) {
        _seconds = cap;
        _playing = false;
        _limitReached = true;
        _timer?.cancel();
      }
    });
  }

  String _fmt(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cap = _preview ? _kPreviewSeconds : _totalSeconds;
    final progress = cap == 0 ? 0.0 : (_seconds / cap).clamp(0.0, 1.0);
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
          // Na prévia o áudio não é navegável — reflete apenas a amostra decorrida.
          child: Slider(
            value: progress.toDouble(),
            onChanged: _preview
                ? null
                : (v) => setState(() => _seconds = (v * _totalSeconds).round()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(_seconds), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              Text(_preview ? 'Amostra 00:30' : '28:00', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
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
              onTap: _togglePlay,
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: _limitReached ? AppColors.outline : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(_limitReached ? Icons.lock_outline : (_playing ? Icons.pause : Icons.play_arrow), color: Colors.white, size: 38),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(tooltip: 'Avançar 30 segundos', iconSize: 34, onPressed: () {}, icon: const Icon(Icons.forward_30, color: AppColors.primary)),
          ],
        ),
        if (_preview && _limitReached) ...[
          const SizedBox(height: 20),
          _previewGate(context),
        ],
        const SizedBox(height: 24),
        // No modo prévia (visitante), ouvir offline fica bloqueado — só membros.
        OutlinedButton.icon(
          onPressed: _preview
              ? () => Navigator.pushNamed(context, AppRoutes.register1)
              : () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Episódio disponível offline'), behavior: SnackBarBehavior.floating)),
          icon: Icon(_preview ? Icons.lock_outline : Icons.download_outlined),
          label: Text(_preview ? 'Ouvir offline — exclusivo para membros' : 'Descarregar para ouvir offline'),
          style: OutlinedButton.styleFrom(
              foregroundColor: _preview ? AppColors.secondary : AppColors.primary,
              side: BorderSide(color: _preview ? AppColors.outlineVariant : AppColors.primary),
              minimumSize: const Size.fromHeight(50)),
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

  Widget _previewGate(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('Continue a ouvir', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15))),
        ]),
        const SizedBox(height: 6),
        Text('Ouviu os primeiros 30 segundos. Crie uma conta gratuita para ouvir o episódio completo.',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.35)),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register1),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Criar conta'),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
            child: const Text('Já tenho conta — Entrar'),
          ),
        ),
      ]),
    );
  }
}
