import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Catálogo de ilustrações vetoriais locais (offline, sem dependências).
///
/// Desenhadas com [CustomPainter] puro — leves, escaláveis e coerentes com a
/// paleta bordeaux/cinzento e o tema "Economia com História – Angola".
enum EhScene {
  currency, // notas de Kwanza / reformas monetárias
  market, // rotas comerciais / mercado
  institution, // instituições / economia política
  map, // mapa de Angola / exploração regional
  rubber, // ciclo da borracha / planalto
  podcast, // áudio / podcast
}

class EhIllustration extends StatelessWidget {
  const EhIllustration({
    super.key,
    required this.scene,
    this.height = 180,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
    this.tone,
    this.semanticLabel,
    this.imageUrl,
    this.fallbackIcon,
  });

  final EhScene scene;
  final double height;

  /// Símbolo do tipo de conteúdo (ex.: livro para artigo, microfone para
  /// podcast, play para vídeo) apresentado como capa quando o autor **não**
  /// carregou uma imagem própria. Quando indicado, substitui a ilustração de
  /// cena por um símbolo limpo sobre fundo da paleta. `null` mantém a cena.
  final IconData? fallbackIcon;

  /// Largura da ilustração. Por omissão preenche a largura disponível
  /// (`double.infinity`), o que é válido em colunas/listas. Em contextos de
  /// largura ilimitada (ex.: dentro de um [Row]) é obrigatório indicar uma
  /// largura finita, caso contrário o `CustomPaint` recebe largura infinita.
  final double width;
  final BorderRadius borderRadius;

  /// Cor base do "céu"/fundo. Por omissão usa um tom quente da paleta.
  final Color? tone;

  /// Descrição para leitores de ecrã (acessibilidade).
  final String? semanticLabel;

  /// URL externa (CDN/internet) a tentar primeiro. Quando indicada, a imagem
  /// é a mesma em qualquer máquina (consistência entre sistemas). Se falhar
  /// — offline, erro de rede ou 404 — recorre automaticamente à ilustração
  /// vetorial desenhada em código, pelo que continua a funcionar offline.
  /// Por omissão usa [_defaultUrl] para a cena.
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl ?? _defaultUrl(scene);
    return Semantics(
      label: semanticLabel ?? _defaultLabel(scene),
      image: true,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          height: height,
          width: width,
          child: _buildImage(url),
        ),
      ),
    );
  }

  /// Camada híbrida: tenta a imagem da internet e, em qualquer falha ou
  /// enquanto carrega, mostra a ilustração vetorial local (fallback garantido).
  Widget _buildImage(String? url) {
    // Sem imagem do autor: mostra o símbolo do tipo (quando indicado) em vez da
    // ilustração de cena, para uma capa limpa e reconhecível pelo formato.
    final fallback = fallbackIcon != null
        ? _IconCover(icon: fallbackIcon!, tone: tone ?? _defaultTone(scene))
        : CustomPaint(
            size: Size.infinite,
            painter: _ScenePainter(scene, tone ?? _defaultTone(scene)),
          );

    if (url == null || url.isEmpty) return fallback;

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      // Enquanto descarrega, mostra a ilustração local (nunca fica vazio).
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : fallback,
      // Sem rede / erro / 404 → ilustração local. Garante consistência offline.
      errorBuilder: (context, error, stack) => fallback,
    );
  }

  /// URLs externas por cena. Centralizadas aqui para fácil substituição por
  /// um CDN próprio. Mantidas como `null` por omissão para não introduzir
  /// dependência de domínios externos que possam ficar indisponíveis; ao
  /// definir um URL aqui (ou via parâmetro), ativa-se o modo online.
  static String? _defaultUrl(EhScene scene) => switch (scene) {
        EhScene.currency => null,
        EhScene.market => null,
        EhScene.institution => null,
        EhScene.map => null,
        EhScene.rubber => null,
        EhScene.podcast => null,
      };

  static String _defaultLabel(EhScene scene) => switch (scene) {
        EhScene.currency => 'Ilustração: moeda e finanças',
        EhScene.market => 'Ilustração: mercado e comércio',
        EhScene.institution => 'Ilustração: instituição',
        EhScene.map => 'Ilustração: mapa de Angola',
        EhScene.rubber => 'Ilustração: planalto e agricultura',
        EhScene.podcast => 'Ilustração: podcast',
      };

  static Color _defaultTone(EhScene scene) => switch (scene) {
        EhScene.currency => const Color(0xFF7A1F1F),
        EhScene.market => const Color(0xFF8A4B1E),
        EhScene.institution => const Color(0xFF003450),
        EhScene.map => const Color(0xFF690008),
        EhScene.rubber => const Color(0xFF5A3210),
        EhScene.podcast => const Color(0xFF45132B),
      };
}

/// Capa de símbolo: fundo em gradiente suave da paleta com o ícone do tipo de
/// conteúdo ao centro. Usada quando o autor não carregou uma imagem própria.
class _IconCover extends StatelessWidget {
  const _IconCover({required this.icon, required this.tone});

  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromColor(tone).withLightness(
                (HSLColor.fromColor(tone).lightness + 0.12).clamp(0.0, 1.0)).toColor(),
            HSLColor.fromColor(tone).withLightness(
                (HSLColor.fromColor(tone).lightness - 0.18).clamp(0.0, 1.0)).toColor(),
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, size: 64, color: Colors.white.withValues(alpha: .92)),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.tone);

  final EhScene scene;
  final Color tone;

  @override
  void paint(Canvas canvas, Size size) {
    // Fundo em gradiente suave (dois tons do mesmo matiz).
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _shift(tone, 0.12),
          _shift(tone, -0.18),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    switch (scene) {
      case EhScene.currency:
        _currency(canvas, size);
      case EhScene.market:
        _market(canvas, size);
      case EhScene.institution:
        _institution(canvas, size);
      case EhScene.map:
        _map(canvas, size);
      case EhScene.rubber:
        _rubber(canvas, size);
      case EhScene.podcast:
        _podcast(canvas, size);
    }
  }

  // ---------------------------------------------------------------- CURRENCY
  void _currency(Canvas canvas, Size s) {
    _sun(canvas, s, Offset(s.width * .82, s.height * .26), s.height * .14);
    // Pilha de notas sobrepostas
    final noteW = s.width * .52;
    final noteH = s.height * .30;
    for (var i = 2; i >= 0; i--) {
      final dx = s.width * .16 + i * 10.0;
      final dy = s.height * .40 + i * 14.0;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(dx, dy, noteW, noteH),
        const Radius.circular(8),
      );
      canvas.drawRRect(rect, Paint()..color = _alpha(Colors.white, .92 - i * .18));
      // detalhe central da nota
      final cx = dx + noteW / 2;
      final cy = dy + noteH / 2;
      canvas.drawCircle(Offset(cx, cy), noteH * .26, Paint()
        ..color = _alpha(tone, .55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
      canvas.drawCircle(Offset(cx, cy), noteH * .12, Paint()..color = _alpha(tone, .35));
      // "Kz"
      _text(canvas, 'Kz', Offset(dx + 10, dy + 8), noteH * .22, _alpha(tone, .8));
    }
  }

  // ------------------------------------------------------------------ MARKET
  void _market(Canvas canvas, Size s) {
    _sun(canvas, s, Offset(s.width * .5, s.height * .24), s.height * .13);
    // Chão
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * .72, s.width, s.height * .28),
      Paint()..color = _shift(tone, -0.3),
    );
    // Bancas do mercado (toldos)
    final stalls = [0.10, 0.40, 0.70];
    for (final f in stalls) {
      final x = s.width * f;
      final w = s.width * .22;
      final topY = s.height * .50;
      // poste
      canvas.drawRect(Rect.fromLTWH(x + w * .1, topY, 4, s.height * .24),
          Paint()..color = _alpha(Colors.white, .5));
      canvas.drawRect(Rect.fromLTWH(x + w * .85, topY, 4, s.height * .24),
          Paint()..color = _alpha(Colors.white, .5));
      // toldo (triângulo)
      final path = Path()
        ..moveTo(x - 6, topY)
        ..lineTo(x + w + 6, topY)
        ..lineTo(x + w * .5, topY - s.height * .12)
        ..close();
      canvas.drawPath(path, Paint()..color = _alpha(Colors.white, .85));
      canvas.drawPath(path, Paint()..color = _alpha(tone, .25));
      // mercadoria
      canvas.drawCircle(Offset(x + w * .5, s.height * .66), s.height * .045,
          Paint()..color = _alpha(AppColors.warning, .9));
    }
  }

  // ------------------------------------------------------------- INSTITUTION
  void _institution(Canvas canvas, Size s) {
    final baseY = s.height * .74;
    final bW = s.width * .56;
    final bX = (s.width - bW) / 2;
    // telhado / frontão
    final ped = Path()
      ..moveTo(bX - 14, s.height * .40)
      ..lineTo(bX + bW + 14, s.height * .40)
      ..lineTo(bX + bW / 2, s.height * .24)
      ..close();
    canvas.drawPath(ped, Paint()..color = _alpha(Colors.white, .9));
    // colunas
    const cols = 4;
    final gap = bW / cols;
    for (var i = 0; i < cols; i++) {
      final cx = bX + gap * i + gap * .5 - 5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx, s.height * .44, 12, baseY - s.height * .44),
          const Radius.circular(3),
        ),
        Paint()..color = _alpha(Colors.white, .82),
      );
    }
    // base / degraus
    canvas.drawRect(Rect.fromLTWH(bX - 18, baseY, bW + 36, 10),
        Paint()..color = _alpha(Colors.white, .9));
    canvas.drawRect(Rect.fromLTWH(bX - 26, baseY + 10, bW + 52, 10),
        Paint()..color = _alpha(Colors.white, .75));
  }

  // --------------------------------------------------------------------- MAP
  void _map(Canvas canvas, Size s) {
    // Forma estilizada (não cartográfica) que evoca o território de Angola.
    final p = Paint()..color = _alpha(Colors.white, .9);
    final w = s.width, h = s.height;
    final path = Path()
      ..moveTo(w * .30, h * .22)
      ..lineTo(w * .68, h * .20)
      ..lineTo(w * .74, h * .34)
      ..lineTo(w * .70, h * .52)
      ..lineTo(w * .76, h * .70)
      ..lineTo(w * .58, h * .82)
      ..lineTo(w * .40, h * .80)
      ..lineTo(w * .30, h * .64)
      ..lineTo(w * .26, h * .42)
      ..close();
    canvas.drawPath(path, p);
    canvas.drawPath(
        path,
        Paint()
          ..color = _alpha(tone, .5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    // "pinos" de localização
    for (final o in [Offset(w * .45, h * .42), Offset(w * .6, h * .58)]) {
      canvas.drawCircle(o, 7, Paint()..color = AppColors.primary);
      canvas.drawCircle(o, 3, Paint()..color = Colors.white);
    }
  }

  // ------------------------------------------------------------------ RUBBER
  void _rubber(Canvas canvas, Size s) {
    _sun(canvas, s, Offset(s.width * .78, s.height * .28), s.height * .12);
    // colinas do planalto
    for (var i = 0; i < 3; i++) {
      final path = Path()
        ..moveTo(0, s.height * (.62 + i * .06))
        ..quadraticBezierTo(
          s.width * (.3 + i * .1), s.height * (.46 + i * .04),
          s.width, s.height * (.60 + i * .07),
        )
        ..lineTo(s.width, s.height)
        ..lineTo(0, s.height)
        ..close();
      canvas.drawPath(path, Paint()..color = _alpha(Colors.white, .18 + i * .14));
    }
    // árvore (tronco + copa)
    final tx = s.width * .26;
    canvas.drawRect(Rect.fromLTWH(tx - 4, s.height * .50, 8, s.height * .22),
        Paint()..color = _alpha(Colors.white, .7));
    canvas.drawCircle(Offset(tx, s.height * .46), s.height * .12,
        Paint()..color = _alpha(AppColors.success, .85));
  }

  // ----------------------------------------------------------------- PODCAST
  void _podcast(Canvas canvas, Size s) {
    final cx = s.width * .5, cy = s.height * .46;
    // microfone
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: s.height * .18, height: s.height * .34),
        Radius.circular(s.height * .09),
      ),
      Paint()..color = _alpha(Colors.white, .92),
    );
    canvas.drawRect(Rect.fromLTWH(cx - 2, cy + s.height * .17, 4, s.height * .14),
        Paint()..color = _alpha(Colors.white, .8));
    canvas.drawRect(Rect.fromLTWH(cx - s.height * .07, cy + s.height * .31, s.height * .14, 5),
        Paint()..color = _alpha(Colors.white, .8));
    // ondas sonoras
    for (var i = 1; i <= 3; i++) {
      final r = s.height * (.18 + i * .07);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -2.6, 1.2, false,
        Paint()
          ..color = _alpha(Colors.white, .5 - i * .12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        0.9, 1.2, false,
        Paint()
          ..color = _alpha(Colors.white, .5 - i * .12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  // -------------------------------------------------------------- utilitários
  void _sun(Canvas canvas, Size s, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = _alpha(AppColors.warning, .85));
    canvas.drawCircle(c, r * 1.7, Paint()..color = _alpha(AppColors.warning, .18));
  }

  void _text(Canvas canvas, String t, Offset at, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at);
  }

  Color _alpha(Color c, double a) => c.withValues(alpha: a.clamp(0, 1));

  /// Clareia (positivo) ou escurece (negativo) uma cor.
  Color _shift(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    final l = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) =>
      old.scene != scene || old.tone != tone;
}
