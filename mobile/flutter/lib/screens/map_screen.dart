import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/data/angola_geometry.dart';
import '../core/routes/app_routes.dart';
import '../services/backend_service.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.preview = false});

  /// Modo visitante (a partir da landing): mostra todas as províncias, mas
  /// apenas 3 ficam disponíveis — as restantes aparecem bloqueadas (cadeado) e
  /// o acesso aos conteúdos só é possível após entrar.
  final bool preview;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

/// Províncias disponíveis no modo prévia (visitante). As restantes ficam
/// bloqueadas, mas continuam visíveis no mapa.
const _previewProvinceIds = {'AOLUA', 'AOBGU', 'AOHUA'};

class _MapScreenState extends State<MapScreen> {
  late final List<AngolaGeo> _geos;
  late final Rect _bounds;
  late final double _aspect;

  String? _selected;
  String? _hovered;

  @override
  void initState() {
    super.initState();
    _geos = angolaGeos();
    _bounds = angolaBounds();
    _aspect = _bounds.width / _bounds.height;
  }

  /// Ids bloqueados no modo prévia (todas menos as disponíveis).
  Set<String> get _lockedIds =>
      _geos.map((g) => g.id).where((id) => !_previewProvinceIds.contains(id)).toSet();

  /// Uma província está bloqueada quando estamos em modo prévia e ela não
  /// pertence ao conjunto de províncias disponíveis.
  bool _isLocked(String id) => widget.preview && !_previewProvinceIds.contains(id);

  void _select(String id) {
    if (_isLocked(id)) {
      setState(() => _selected = id);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Província bloqueada — entre para desbloquear todas.')));
      return;
    }
    setState(() => _selected = _selected == id ? null : id);
  }

  @override
  Widget build(BuildContext context) {
    final selectedGeo = _selected == null ? null : _geos.firstWhere((g) => g.id == _selected);
    final tiles = [..._geos]..sort((a, b) => a.name.compareTo(b.name));
    return ScreenFrame(title: 'Mapa Interativo', showBack: true, children: [
      Text('Explore Angola por província', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
      const SizedBox(height: 6),
      Text(
        widget.preview
            ? 'Explore Angola por província. Nesta amostra, 3 províncias estão disponíveis; '
                'as restantes ficam bloqueadas — entre para desbloquear todas.'
            : 'Toque numa província para ver indicadores económicos, marcos históricos e '
                'conteúdos locais. Uma forma de ligar geografia, economia e história.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
      ),
      const SizedBox(height: 18),

      _interactiveMap(context),
      const SizedBox(height: 14),

      // Cartão de detalhe com animação de entrada suave.
      AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(animation),
              child: child,
            ),
          ),
          child: selectedGeo == null
              ? _hint(context)
              : _ProvinceCard(
                  key: ValueKey(selectedGeo.id),
                  name: selectedGeo.name,
                  locked: _isLocked(selectedGeo.id),
                  onOpen: () => Navigator.pushNamed(
                    context,
                    _isLocked(selectedGeo.id) ? AppRoutes.login : AppRoutes.provinceContents,
                    arguments: _isLocked(selectedGeo.id) ? null : selectedGeo.name,
                  ),
                ),
        ),
      ),
      const SizedBox(height: 24),

      const SectionTitle('Províncias em destaque'),
      const SizedBox(height: 12),
      for (final g in tiles) ...[
        _provinceTile(context, g),
        const SizedBox(height: 10),
      ],
    ]);
  }

  // ---------------------------------------------------------------------------
  // Mapa vetorial interativo (silhueta real de Angola)
  // ---------------------------------------------------------------------------

  Widget _interactiveMap(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final size = Size(width, width / _aspect);
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.navy, Color(0xFF002336)],
              ),
            ),
            child: MouseRegion(
              onHover: (e) => _updateHover(e.localPosition, size),
              onExit: (_) => setState(() => _hovered = null),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => _handleTap(d.localPosition, size),
                child: CustomPaint(
                  size: size,
                  painter: _AngolaMapPainter(
                    geos: _geos,
                    bounds: _bounds,
                    selected: _selected,
                    hovered: _hovered,
                    lockedIds: widget.preview ? _lockedIds : const {},
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Converte um ponto local do mapa para coordenadas do SVG (espaço dos paths).
  Offset _toSvg(Offset local, Size size) {
    final fit = fitAngola(size, _bounds);
    return Offset((local.dx - fit.offset.dx) / fit.scale, (local.dy - fit.offset.dy) / fit.scale);
  }

  void _handleTap(Offset local, Size size) {
    final p = _toSvg(local, size);
    for (final g in _geos) {
      if (g.path.contains(p)) {
        _select(g.id);
        return;
      }
    }
  }

  void _updateHover(Offset local, Size size) {
    final p = _toSvg(local, size);
    String? found;
    for (final g in _geos) {
      if (g.path.contains(p)) {
        found = g.id;
        break;
      }
    }
    if (found != _hovered) setState(() => _hovered = found);
  }

  Widget _hint(BuildContext context) {
    return Container(
      key: const ValueKey('hint'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.touch_app_outlined, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Toque numa província no mapa para ver os seus indicadores e conteúdos.',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  Widget _provinceTile(BuildContext context, AngolaGeo g) {
    final isSelected = _selected == g.id;
    final locked = _isLocked(g.id);
    return Opacity(
      opacity: locked ? .55 : 1,
      child: Material(
        color: isSelected && !locked ? AppColors.surfaceContainer : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _select(g.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected && !locked ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: .4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                  child: Icon(locked ? Icons.lock_outline : Icons.place_outlined, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                      if (locked)
                        Text('Bloqueada — entre para desbloquear',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cartão de informações da província
// ---------------------------------------------------------------------------

class _ProvinceCard extends StatefulWidget {
  const _ProvinceCard({super.key, required this.name, required this.onOpen, this.locked = false});

  final String name;
  final VoidCallback onOpen;

  /// Quando verdadeiro, o acesso aos conteúdos está bloqueado (modo visitante).
  final bool locked;

  @override
  State<_ProvinceCard> createState() => _ProvinceCardState();
}

class _ProvinceCardState extends State<_ProvinceCard> {
  /// Contagens reais da província (conteúdos + autores). Só carregadas quando
  /// a província não está bloqueada; ficam a `null` enquanto carregam.
  late final Future<({int contents, int authors})>? _statsF =
      widget.locked ? null : BackendService.instance.provinceStats(widget.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.location_on_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
              ),
            ],
          ),
          // Contagens reais — só quando a província está desbloqueada.
          if (_statsF != null) ...[
            const SizedBox(height: 16),
            FutureBuilder<({int contents, int authors})>(
              future: _statsF,
              builder: (context, snapshot) {
                final stats = snapshot.data ?? (contents: 0, authors: 0);
                return Row(
                  children: [
                    Expanded(child: _stat(context, Icons.layers_outlined, '${stats.contents}', 'Conteúdos')),
                    Expanded(child: _stat(context, Icons.people_outline, '${stats.authors}', 'Autores')),
                  ],
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onOpen,
              style: FilledButton.styleFrom(
                backgroundColor: widget.locked ? AppColors.surfaceContainer : AppColors.primary,
                foregroundColor: widget.locked ? AppColors.secondary : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(widget.locked ? Icons.lock_outline : Icons.menu_book_outlined, size: 18),
              label: Text(widget.locked ? 'ENTRE PARA VER CONTEÚDOS' : 'VER CONTEÚDOS'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Render do mapa
// ---------------------------------------------------------------------------

class _AngolaMapPainter extends CustomPainter {
  _AngolaMapPainter({
    required this.geos,
    required this.bounds,
    required this.selected,
    required this.hovered,
    this.lockedIds = const {},
  });

  final List<AngolaGeo> geos;
  final Rect bounds;
  final String? selected;
  final String? hovered;

  /// Províncias bloqueadas (modo prévia): pintadas esbatidas e com cadeado.
  final Set<String> lockedIds;

  @override
  void paint(Canvas canvas, Size size) {
    final fit = fitAngola(size, bounds);

    canvas.save();
    canvas.translate(fit.offset.dx, fit.offset.dy);
    canvas.scale(fit.scale);

    final fill = Paint()..style = PaintingStyle.fill;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 0.7 / fit.scale;

    for (final g in geos) {
      final isLocked = lockedIds.contains(g.id);
      final isSelected = g.id == selected;
      final isHovered = g.id == hovered;
      fill.color = isLocked
          ? const Color(0xFF012A3E)
          : isSelected
              ? AppColors.primary
              : isHovered
                  ? AppColors.navyContainer
                  : const Color(0xFF013A55);
      canvas.drawPath(g.path, fill);
      border.color = isSelected && !isLocked ? Colors.white : Colors.white.withValues(alpha: isLocked ? .10 : .22);
      canvas.drawPath(g.path, border);
    }

    canvas.restore();

    // Cadeados nas províncias bloqueadas.
    for (final g in geos) {
      if (!lockedIds.contains(g.id)) continue;
      final center = Offset(
        fit.offset.dx + g.centroid.dx * fit.scale,
        fit.offset.dy + g.centroid.dy * fit.scale,
      );
      _paintLock(canvas, center);
    }

    // Rótulo da província ativa (selecionada tem prioridade sobre hover), exceto
    // quando bloqueada — aí basta o cadeado.
    final labelId = selected ?? hovered;
    if (labelId != null && !lockedIds.contains(labelId)) {
      final g = geos.firstWhere((e) => e.id == labelId);
      final center = Offset(
        fit.offset.dx + g.centroid.dx * fit.scale,
        fit.offset.dy + g.centroid.dy * fit.scale,
      );
      _paintLabel(canvas, g.name, center);
    }
  }

  void _paintLock(Canvas canvas, Offset center) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.lock.codePoint),
        style: const TextStyle(fontSize: 12, fontFamily: 'MaterialIcons', color: Colors.white70),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _paintLabel(Canvas canvas, String text, Offset center) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final pad = const Offset(8, 4);
    final rect = Rect.fromCenter(
      center: center,
      width: tp.width + pad.dx * 2,
      height: tp.height + pad.dy * 2,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(99));
    canvas.drawShadow(Path()..addRRect(rrect), Colors.black.withValues(alpha: .4), 3, false);
    canvas.drawRRect(rrect, Paint()..color = Colors.white);
    tp.paint(canvas, Offset(rect.left + pad.dx, rect.top + pad.dy));
  }

  @override
  bool shouldRepaint(covariant _AngolaMapPainter old) =>
      old.selected != selected || old.hovered != hovered || old.lockedIds != lockedIds;
}
