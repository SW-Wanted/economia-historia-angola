import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const provinces = ['Luanda', 'Benguela', 'Uige', 'Namibe', 'Huambo', 'Cabinda'];
    return ScreenFrame(title: 'Mapa Interativo', showBack: true, children: [
      EhCard(
        color: AppColors.surfaceHighest,
        child: AspectRatio(
          aspectRatio: .9,
          child: Stack(children: [
            Center(child: Icon(Icons.map, size: 180, color: AppColors.primary.withValues(alpha: .28))),
            for (var i = 0; i < provinces.length; i++)
              Positioned(
                left: 40 + (i % 2) * 150,
                top: 40 + i * 45,
                child: ActionChip(
                  label: Text(provinces[i]),
                  avatar: const Icon(Icons.location_on, size: 16),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.provinceContents),
                ),
              ),
          ]),
        ),
      ),
      const SizedBox(height: 18),
      const Text('Toque numa provincia para ver eventos, microtextos e temas economicos regionais.'),
    ]);
  }
}
