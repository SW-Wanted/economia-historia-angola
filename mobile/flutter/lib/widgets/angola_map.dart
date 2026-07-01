import 'package:flutter/material.dart';

import '../core/data/angola_geometry.dart';

/// Mapa de Angola (silhueta real das 18 províncias), estático e leve.
///
/// Vetorial — desenhado em canvas a partir da geometria partilhada, sem
/// imagens nem dependências externas. Ideal para banners e thumbnails.
class AngolaMap extends StatelessWidget {
  const AngolaMap({
    super.key,
    this.fill = Colors.white,
    this.border,
    this.borderWidth = 0.7,
    this.markerIds = const [],
    this.markerColor = const Color(0xFF8B1A1A),
  });

  /// Cor de preenchimento das províncias.
  final Color fill;

  /// Cor das fronteiras internas; se nulo, usa o [fill] esbatido.
  final Color? border;
  final double borderWidth;

  /// Ids de províncias a destacar com um marcador.
  final List<String> markerIds;
  final Color markerColor;

  @override
  Widget build(BuildContext context) {
    final bounds = angolaBounds();
    return AspectRatio(
      aspectRatio: bounds.width / bounds.height,
      child: CustomPaint(
        painter: _AngolaMapThumbPainter(
          fill: fill,
          border: border ?? fill.withValues(alpha: .35),
          borderWidth: borderWidth,
          markerIds: markerIds,
          markerColor: markerColor,
        ),
      ),
    );
  }
}

class _AngolaMapThumbPainter extends CustomPainter {
  _AngolaMapThumbPainter({
    required this.fill,
    required this.border,
    required this.borderWidth,
    required this.markerIds,
    required this.markerColor,
  });

  final Color fill;
  final Color border;
  final double borderWidth;
  final List<String> markerIds;
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final geos = angolaGeos();
    final bounds = angolaBounds();
    final fit = fitAngola(size, bounds);

    canvas.save();
    canvas.translate(fit.offset.dx, fit.offset.dy);
    canvas.scale(fit.scale);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = borderWidth / fit.scale
      ..color = border;

    for (final g in geos) {
      canvas.drawPath(g.path, fillPaint);
      canvas.drawPath(g.path, borderPaint);
    }
    canvas.restore();

    // Marcadores opcionais sobre as províncias indicadas.
    for (final id in markerIds) {
      final g = geos.where((e) => e.id == id);
      if (g.isEmpty) continue;
      final c = g.first.centroid;
      final center = Offset(fit.offset.dx + c.dx * fit.scale, fit.offset.dy + c.dy * fit.scale);
      canvas.drawCircle(center, 5.5, Paint()..color = Colors.white);
      canvas.drawCircle(center, 4, Paint()..color = markerColor);
    }
  }

  @override
  bool shouldRepaint(covariant _AngolaMapThumbPainter old) =>
      old.fill != fill ||
      old.border != border ||
      old.markerColor != markerColor ||
      old.markerIds != markerIds;
}
