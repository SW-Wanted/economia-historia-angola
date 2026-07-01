import 'dart:ui';

import 'angola_provinces.dart';

/// Província já com geometria parseada e centróide (para rótulos/marcadores).
class AngolaGeo {
  AngolaGeo(this.id, this.name, this.path) : centroid = path.getBounds().center;
  final String id;
  final String name;
  final Path path;
  final Offset centroid;
}

List<AngolaGeo>? _cachedGeos;
Rect? _cachedBounds;

/// Geometria das 18 províncias, parseada uma única vez e reutilizada.
List<AngolaGeo> angolaGeos() {
  return _cachedGeos ??= [
    for (final p in angolaProvincePaths) AngolaGeo(p.id, p.name, parseSvgPath(p.path)),
  ];
}

/// Limites combinados de todas as províncias (espaço do SVG).
Rect angolaBounds() {
  if (_cachedBounds != null) return _cachedBounds!;
  final geos = angolaGeos();
  var bounds = geos.first.path.getBounds();
  for (final g in geos) {
    bounds = bounds.expandToInclude(g.path.getBounds());
  }
  return _cachedBounds = bounds;
}

/// Ajuste "contain" da geometria SVG ao tamanho do canvas, com margem.
({double scale, Offset offset}) fitAngola(Size size, Rect bounds, {double margin = 0.94}) {
  final scale = (size.width / bounds.width) * margin;
  final dx = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
  final dy = (size.height - bounds.height * scale) / 2 - bounds.top * scale;
  return (scale: scale, offset: Offset(dx, dy));
}

// ---------------------------------------------------------------------------
// Parser mínimo de path SVG (apenas comandos M, m, L, l, H, h, V, v, Z, z)
// ---------------------------------------------------------------------------

final _tokenRe = RegExp(r'[MmLlHhVvZz]|-?\d*\.?\d+(?:e[-+]?\d+)?', caseSensitive: false);
final _letterRe = RegExp(r'^[A-Za-z]$');

Path parseSvgPath(String d) {
  final path = Path();
  final tokens = _tokenRe.allMatches(d).map((m) => m.group(0)!).toList();
  double cx = 0, cy = 0, sx = 0, sy = 0;
  String cmd = '';
  var i = 0;
  double next() => double.parse(tokens[i++]);

  while (i < tokens.length) {
    final t = tokens[i];
    if (_letterRe.hasMatch(t)) {
      cmd = t;
      i++;
      if (cmd == 'Z' || cmd == 'z') {
        path.close();
        cx = sx;
        cy = sy;
      }
      continue;
    }
    switch (cmd) {
      case 'M':
        cx = next();
        cy = next();
        path.moveTo(cx, cy);
        sx = cx;
        sy = cy;
        cmd = 'L';
      case 'm':
        cx += next();
        cy += next();
        path.moveTo(cx, cy);
        sx = cx;
        sy = cy;
        cmd = 'l';
      case 'L':
        cx = next();
        cy = next();
        path.lineTo(cx, cy);
      case 'l':
        cx += next();
        cy += next();
        path.lineTo(cx, cy);
      case 'H':
        cx = next();
        path.lineTo(cx, cy);
      case 'h':
        cx += next();
        path.lineTo(cx, cy);
      case 'V':
        cy = next();
        path.lineTo(cx, cy);
      case 'v':
        cy += next();
        path.lineTo(cx, cy);
      default:
        i++; // ignora comandos não suportados
    }
  }
  return path;
}
