import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

/// Duração da amostra gratuita (modo prévia): 30 segundos.
const _kPreviewSeconds = 30;

/// Leitor de vídeo. Quando recebe um [content] com media real (ficheiro
/// carregado na criação ou ligação externa), reproduz o vídeo verdadeiro. Sem
/// media — ou no modo prévia de visitante — mostra um marcador simples.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, this.content, this.preview = false});

  final FeedContent? content;
  final bool preview;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _ready = false;
  String? _error;

  /// Modo prévia (visitante): limita a reprodução aos primeiros 30 segundos.
  bool get _preview => widget.preview;

  String? get _mediaUrl => widget.content?.playbackUrl;

  String get _title => widget.content?.title ?? 'A história do Caminho de Ferro de Benguela';

  String get _description =>
      widget.content?.body ??
      (_preview
          ? 'Amostra gratuita de 30 segundos. Crie uma conta para ver o vídeo completo.'
          : 'Aula visual com marcadores, transcrição e progresso guardado.');

  @override
  void initState() {
    super.initState();
    final url = _mediaUrl;
    if (url != null) _initPlayer(url);
  }

  Future<void> _initPlayer(String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller = controller;
    controller.addListener(_onTick);
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Não foi possível carregar o vídeo.');
    }
  }

  /// No modo prévia, corta a reprodução ao atingir a amostra de 30s.
  void _onTick() {
    final controller = _controller;
    if (controller == null || !_preview) return;
    if (controller.value.position.inSeconds >= _kPreviewSeconds && controller.value.isPlaying) {
      controller.pause();
      controller.seekTo(const Duration(seconds: _kPreviewSeconds));
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null || !_ready) return;
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        // Se a amostra terminou, reinicia do começo antes de tocar.
        if (_preview && controller.value.position.inSeconds >= _kPreviewSeconds) {
          controller.seekTo(Duration.zero);
        }
        controller.play();
      }
    });
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Player de Vídeo', showBack: true, children: [
      EhCard(
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: _ready && _controller != null ? _controller!.value.aspectRatio : 16 / 9,
          child: Stack(alignment: Alignment.center, children: [
            if (_ready && _controller != null) VideoPlayer(_controller!) else _placeholder(),
            _overlay(context),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      _progressBar(),
      const SizedBox(height: 18),
      Text(_title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      Text(_description),
      if (_preview && _previewEnded) ...[
        const SizedBox(height: 16),
        _previewGate(context),
      ],
    ]);
  }

  bool get _previewEnded =>
      _preview && _controller != null && _controller!.value.position.inSeconds >= _kPreviewSeconds;

  Widget _placeholder() => Icon(Icons.history_edu, color: Colors.white.withValues(alpha: .16), size: 92);

  Widget _overlay(BuildContext context) {
    if (_error != null) {
      return Container(
        color: Colors.black.withValues(alpha: .55),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      );
    }
    if (_mediaUrl != null && !_ready) {
      return const CircularProgressIndicator(color: Colors.white);
    }
    if (_previewEnded) return _limitOverlay(context);
    // Sem media reproduzível: mantém o botão ilustrativo (não faz nada útil,
    // mas preserva a aparência para conteúdos sem ficheiro).
    final playing = _controller?.value.isPlaying ?? false;
    return GestureDetector(
      onTap: _mediaUrl == null ? null : _togglePlay,
      child: CircleAvatar(
        radius: 34,
        backgroundColor: AppColors.primary,
        child: Icon(playing ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 42),
      ),
    );
  }

  Widget _progressBar() {
    final controller = _controller;
    final position = controller?.value.position ?? Duration.zero;
    final total = _preview
        ? const Duration(seconds: _kPreviewSeconds)
        : (controller?.value.duration ?? Duration.zero);
    final value = total.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 5,
          backgroundColor: AppColors.outlineVariant,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(_fmt(position), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        Text(_preview ? 'Amostra 00:30' : _fmt(total),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]),
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
