import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // Dados fictícios coerentes com o contexto angolano.
  static const _provinces = [
    _Prov('Luanda', 'Serviços e comércio', '11,2%', Alignment(-0.25, 0.05)),
    _Prov('Benguela', 'Pesca e porto do Lobito', '9,8%', Alignment(-0.45, 0.45)),
    _Prov('Huíla', 'Agricultura e pecuária', '8,5%', Alignment(-0.05, 0.7)),
    _Prov('Huambo', 'Planalto central', '10,1%', Alignment(0.1, 0.35)),
    _Prov('Uíge', 'Café e agricultura', '7,9%', Alignment(0.2, -0.5)),
    _Prov('Cabinda', 'Petróleo', '12,4%', Alignment(-0.55, -0.75)),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Mapa Interativo', showBack: true, children: [
      Text('Explore Angola por província', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
      const SizedBox(height: 6),
      Text(
        'Toque numa província para ver indicadores económicos, marcos históricos e '
        'conteúdos locais. Uma forma de ligar geografia, economia e história.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
      ),
      const SizedBox(height: 18),

      // Mapa ilustrado com pinos posicionados
      Stack(
        children: [
          EhIllustration(
            scene: EhScene.map,
            height: 300,
            borderRadius: BorderRadius.circular(24),
            tone: const Color(0xFF7A1F1F),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  for (final p in _provinces)
                    Align(
                      alignment: p.pos,
                      child: _pin(context, p),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // Legenda
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text('A percentagem indica o peso estimado da província na economia (dados ilustrativos).',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),

      const SectionTitle('Províncias em destaque'),
      const SizedBox(height: 12),
      for (final p in _provinces) ...[
        _provinceTile(context, p),
        const SizedBox(height: 10),
      ],
    ]);
  }

  Widget _pin(BuildContext context, _Prov p) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.provinceContents),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .2), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 15),
            const SizedBox(width: 4),
            Text(p.name, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _provinceTile(BuildContext context, _Prov p) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, AppRoutes.provinceContents),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
          ),
          child: Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.place_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                    Text(p.focus, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(p.weight, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  Text('da economia', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Prov {
  const _Prov(this.name, this.focus, this.weight, this.pos);
  final String name;
  final String focus;
  final String weight;
  final Alignment pos;
}
