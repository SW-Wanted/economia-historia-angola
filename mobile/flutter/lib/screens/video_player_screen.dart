import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

/// Duração da amostra gratuita (modo prévia): 30 segundos.
const _kPreviewSeconds = 30;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const _totalSeconds = 8 * 60; // duração ilustrativa do vídeo completo.

  bool _preview = false;
  bool _initialized = false;
  bool _playing = false;
  bool _limitReached = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // `arguments == true` → modo prévia (visitante): só os primeiros 30s.
    _preview = ModalRoute.of(context)?.settings.arguments == true;
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
    return ScreenFrame(title: 'Player de Vídeo', showBack: true, children: [
      EhCard(
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(alignment: Alignment.center, children: [
            Icon(Icons.history_edu, color: Colors.white.withValues(alpha: .16), size: 92),
            if (_limitReached)
              _limitOverlay(context)
            else
              GestureDetector(
                onTap: _togglePlay,
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.primary,
                  child: Icon(_playing ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 42),
                ),
              ),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      // Barra de progresso simples.
      ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LinearProgressIndicator(
          value: cap == 0 ? 0 : _seconds / cap,
          minHeight: 5,
          backgroundColor: AppColors.outlineVariant,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_fmt(_seconds), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        Text(_preview ? 'Amostra 00:30' : _fmt(_totalSeconds),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]),
      const SizedBox(height: 18),
      Text('A história do Caminho de Ferro de Benguela', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text(_preview
          ? 'Amostra gratuita de 30 segundos. Crie uma conta para ver o vídeo completo.'
          : 'Aula visual com marcadores, transcricao e progresso guardado.'),
      if (_preview && _limitReached) ...[
        const SizedBox(height: 16),
        _previewGate(context),
      ],
    ]);
  }

  Widget _limitOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: .55),
      alignment: Alignment.center,
      child: const Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.lock_outline, color: Colors.white, size: 40),
        SizedBox(height: 8),
        Text('Fim da amostra de 30s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _previewGate(BuildContext context) {
    return EhCard(
      color: AppColors.surfaceLow,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Continue a ver', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
        const SizedBox(height: 6),
        Text('Viu os primeiros 30 segundos. Crie uma conta gratuita para ver o vídeo completo.',
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
