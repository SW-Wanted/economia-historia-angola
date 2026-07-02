import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'app_logo_mark.dart';

/// Animação de carregamento oficial da aplicação.
///
/// Substitui os indicadores genéricos por uma sequência temática de História da
/// Economia: o logótipo permanece sempre no centro (com leve flutuação e brilho)
/// enquanto ícones relacionados (livro, museu, moeda, agricultura, petróleo,
/// educação, fórum…) surgem um de cada vez à volta, com fade + escala + rotação
/// subtil. Por baixo, três pontos pulsam continuamente.
///
/// É conduzida por um único [AnimationController] (um ticker) para garantir
/// fluidez a 60 FPS e baixo custo. Ver [AppLoadingOverlay] para o ecrã completo.
class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 120,
    this.message,
    this.showDots = true,
  });

  /// Diâmetro da área da animação (logótipo + órbita de ícones).
  final double size;

  /// Mensagem discreta opcional (ex.: "A organizar conhecimento...").
  final String? message;

  final bool showDots;

  /// Ícones temáticos que orbitam o logótipo, na ordem de aparecimento.
  static const _icons = <IconData>[
    Icons.menu_book_outlined, // Livro
    Icons.description_outlined, // Documento histórico
    Icons.account_balance_outlined, // Museu
    Icons.public, // Globo
    Icons.trending_up, // Economia
    Icons.paid_outlined, // Moeda
    Icons.grass_outlined, // Agricultura
    Icons.factory_outlined, // Indústria
    Icons.local_gas_station_outlined, // Petróleo
    Icons.local_library_outlined, // Biblioteca
    Icons.school_outlined, // Educação
    Icons.edit_outlined, // Escritor
    Icons.headphones_outlined, // Podcast
    Icons.play_circle_outline, // Vídeo
    Icons.forum_outlined, // Fórum
    Icons.psychology_outlined, // Conhecimento
    Icons.map_outlined, // História / mapa
  ];

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 6600))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = widget.size * 0.42;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Halo suave que respira atrás do logótipo.
                  _halo(),
                  // Ícones temáticos, um de cada vez, em órbita.
                  ..._orbitIcons(),
                  // Logótipo central — sempre visível, com leve flutuação/escala.
                  child!,
                ],
              );
            },
            child: _centerLogo(logoSize),
          ),
        ),
        if (widget.showDots) ...[
          SizedBox(height: widget.size * 0.14),
          _Dots(controller: _c),
        ],
        if (widget.message != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.message!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: .2),
          ),
        ],
      ],
    );
  }

  Widget _halo() {
    // Pulsação lenta (0..1..0) independente da órbita.
    final t = (math.sin(_c.value * 2 * math.pi) + 1) / 2;
    final scale = 0.82 + t * 0.22;
    return Opacity(
      opacity: 0.10 + t * 0.10,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size * 0.7,
          height: widget.size * 0.7,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _centerLogo(double logoSize) {
    // Flutuação vertical + micro-escala, sincronizadas mas subtis.
    final wave = math.sin(_c.value * 2 * math.pi);
    final dy = wave * 3.0;
    final scale = 1 + wave * 0.04;
    return Transform.translate(
      offset: Offset(0, dy),
      child: Transform.scale(
        scale: scale,
        child: AppLogoMark(size: logoSize, elevation: 10),
      ),
    );
  }

  /// Constrói os ícones em órbita. Mostramos uma pequena janela de ícones
  /// consecutivos, cada um com o seu próprio ciclo de fade/escala, dando a
  /// sensação de "um de cada vez" a dar lugar ao seguinte.
  List<Widget> _orbitIcons() {
    const visible = 3; // quantos ícones coexistem (em fases diferentes).
    final icons = AppLoadingIndicator._icons;
    final n = icons.length;
    final progress = _c.value * n; // avança 1 índice por "passo".
    final radius = widget.size * 0.34;

    final widgets = <Widget>[];
    for (var k = 0; k < visible; k++) {
      // Fase local de cada ícone (0→1); desfasadas entre si.
      final phase = (progress + k / visible) % 1.0;
      final index = ((progress + k / visible).floor()) % n;
      final icon = icons[index];

      // Envelope de opacidade/escala: surge, cresce e desvanece.
      final env = math.sin(phase * math.pi); // 0 → 1 → 0
      final opacity = (env * env).clamp(0.0, 1.0);
      final scale = 0.6 + env * 0.6;

      // Posição angular: cada ícone entra numa direção diferente e roda devagar.
      final angle = (index / n) * 2 * math.pi + _c.value * 0.6;
      final dx = math.cos(angle) * radius * (0.7 + env * 0.3);
      final dy = math.sin(angle) * radius * (0.7 + env * 0.3);

      widgets.add(
        Transform.translate(
          offset: Offset(dx, dy),
          child: Opacity(
            opacity: opacity * 0.9,
            child: Transform.rotate(
              angle: (env - 0.5) * 0.25, // rotação muito subtil
              child: Transform.scale(
                scale: scale,
                child: Icon(icon, size: widget.size * 0.18, color: AppColors.primary.withValues(alpha: .85)),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

/// Três pontos que pulsam em sequência (● ○ ○ → ○ ● ○ → ○ ○ ●).
class _Dots extends StatelessWidget {
  const _Dots({required this.controller});
  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Ciclo próprio dos pontos (mais rápido que a órbita).
        final t = (controller.value * 3) % 1.0;
        final active = (t * 3).floor() % 3;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final on = i == active;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: on ? 9 : 7,
              height: on ? 9 : 7,
              decoration: BoxDecoration(
                color: on ? AppColors.primary : AppColors.primary.withValues(alpha: .28),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

/// Overlay de ecrã inteiro (com fundo semi-opaco) para bloquear a interação
/// enquanto algo carrega — usa a mesma [AppLoadingIndicator] no centro.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, this.message = 'A organizar conhecimento...'});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background.withValues(alpha: .82),
      alignment: Alignment.center,
      child: AppLoadingIndicator(message: message),
    );
  }
}
