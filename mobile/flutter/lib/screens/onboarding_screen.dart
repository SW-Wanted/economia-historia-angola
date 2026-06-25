import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.step});

  final int step;

  static const _data = [
    ('Aprenda com contexto', 'Microtextos claros ligam história, economia e cultura angolana.', Icons.auto_stories_outlined),
    ('Explore por província', 'Mapas e temas ajudam a perceber como cada regiao moldou o pais.', Icons.map_outlined),
    ('Teste e participe', 'Quizzes, ranking e fórum tornam a aprendizagem viva e comunitaria.', Icons.quiz_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final item = _data[step - 1];
    final next = step == 1 ? AppRoutes.onboarding2 : step == 2 ? AppRoutes.onboarding3 : AppRoutes.landing;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              if (step > 1) IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)) else const SizedBox(width: 48),
              TextButton(onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing), child: const Text('Pular')),
            ]),
            const Spacer(),
            Center(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(44)),
                child: Icon(item.$3, size: 96, color: AppColors.primary),
              ),
            ),
            const Spacer(),
            Text(item.$1, style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            Text(item.$2, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 28),
            Row(children: List.generate(3, (i) => Expanded(child: Container(margin: const EdgeInsets.only(right: 8), height: 4, decoration: BoxDecoration(color: i < step ? AppColors.primary : AppColors.outlineVariant, borderRadius: BorderRadius.circular(99)))))),
            const SizedBox(height: 28),
            EhButton(label: step == 3 ? 'Começar agora' : 'Proximo', onPressed: () => Navigator.pushNamed(context, next)),
          ]),
        ),
      ),
    );
  }
}
