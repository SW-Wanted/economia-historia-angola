import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/screen_frame.dart';

/// Duração da amostra gratuita (modo prévia): 30 segundos.
const _kPreviewSeconds = 30;

/// Leitor de podcast. Quando recebe um [content] com áudio real (ficheiro
/// carregado na criação ou ligação externa), reproduz o áudio verdadeiro. Sem
/// media — ou no modo prévia de visitante — mostra um leitor ilustrativo.
class PodcastPlayerScreen extends StatefulWidget {
  const PodcastPlayerScreen({super.key, this.content, this.preview = false});

  final FeedContent? content;
  final bool preview;

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  AudioPlayer? _player;
  bool _ready = false;
  String? _error;
  Duration _position = Duration.zero;
  Duration _total = Duration.zero;
  final _subs = <StreamSubscription<dynamic>>[];

  bool get _preview => widget.preview;

  String? get _mediaUrl => widget.content?.playbackUrl;

  String get _title => widget.content?.title ?? 'O Petróleo e o Futuro de Angola';

  /// Rótulo apresentado acima do título: o tipo do conteúdo ("Podcast"), não a
  /// categoria editorial (que pode ter sido gravada como "Artigo").
  String get _category => widget.content?.type.label ?? 'Podcast';

  String get _description =>
      widget.content?.body ??
      'Uma conversa sobre a dependência do petróleo na economia angolana e os '
          'caminhos para a diversificação, ligando história e presente.';

  @override
  void initState() {
    super.initState();
    final url = _mediaUrl;
    if (url != null) _initPlayer(url);
  }

  Future<void> _initPlayer(String url) async {
    final player = AudioPlayer();
    _player = player;
    _subs.add(player.positionStream.listen((p) {
      if (!mounted) return;
      // No modo prévia, corta a reprodução ao atingir os 30s de amostra.
      if (_preview && p.inSeconds >= _kPreviewSeconds) {
        player.pause();
        player.seek(const Duration(seconds: _kPreviewSeconds));
      }
      setState(() => _position = p);
    }));
    _subs.add(player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    }));
    try {
      final duration = await player.setUrl(url);
      if (!mounted) return;
      setState(() {
        _total = duration ?? Duration.zero;
        _ready = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Não foi possível carregar o áudio.');
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player?.dispose();
    super.dispose();
  }

  bool get _playing => _player?.playing ?? false;

  bool get _previewEnded => _preview && _position.inSeconds >= _kPreviewSeconds;

  void _togglePlay() {
    final player = _player;
    if (player == null || !_ready) return;
    if (_playing) {
      player.pause();
    } else {
      if (_preview && _position.inSeconds >= _kPreviewSeconds) {
        player.seek(Duration.zero);
      }
      player.play();
    }
  }

  Future<void> _seekBy(int seconds) async {
    final player = _player;
    if (player == null || !_ready) return;
    var target = _position + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    final cap = _preview ? const Duration(seconds: _kPreviewSeconds) : _total;
    if (cap > Duration.zero && target > cap) target = cap;
    await player.seek(target);
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cap = _preview ? const Duration(seconds: _kPreviewSeconds) : _total;
    final progress = cap.inMilliseconds == 0
        ? 0.0
        : (_position.inMilliseconds / cap.inMilliseconds).clamp(0.0, 1.0);
    return ScreenFrame(
      title: 'Podcast',
      showBack: true,
      children: [
        EhIllustration(
          scene: EhScene.podcast,
          imageUrl: widget.content?.imageUrl,
          fallbackIcon: Icons.mic_none_outlined,
          height: 200,
          borderRadius: BorderRadius.circular(24),
        ),
        const SizedBox(height: 24),
        Text(_category, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(_title, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
        const SizedBox(height: 24),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(_error!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.error)),
          ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.outlineVariant,
            thumbColor: AppColors.primary,
            trackHeight: 4,
          ),
          child: Slider(
            value: progress.toDouble(),
            // Sem media (ou prévia) o slider não é navegável.
            onChanged: (!_ready || _preview)
                ? null
                : (v) => _player?.seek(Duration(milliseconds: (v * _total.inMilliseconds).round())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(_position), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              Text(_preview ? 'Amostra 00:30' : _fmt(_total),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(tooltip: 'Recuar 10 segundos', iconSize: 34, onPressed: _ready ? () => _seekBy(-10) : null, icon: const Icon(Icons.replay_10, color: AppColors.primary)),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: _togglePlay,
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: _previewEnded ? AppColors.outline : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(_previewEnded ? Icons.lock_outline : (_playing ? Icons.pause : Icons.play_arrow), color: Colors.white, size: 38),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(tooltip: 'Avançar 30 segundos', iconSize: 34, onPressed: _ready ? () => _seekBy(30) : null, icon: const Icon(Icons.forward_30, color: AppColors.primary)),
          ],
        ),
        if (_preview && _previewEnded) ...[
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
          _description,
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
