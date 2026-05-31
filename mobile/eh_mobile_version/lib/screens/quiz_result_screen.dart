import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Resultado do Quiz', showBack: true, children: [
      EhCard(
        child: Column(children: [
          const Icon(Icons.emoji_events, color: AppColors.warning, size: 76),
          const SizedBox(height: 10),
          Text('8/10', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary, fontSize: 44)),
          const Text('Excelente dominio do tema cafe e economia regional.'),
        ]),
      ),
      const SizedBox(height: 24),
      EhButton(label: 'Ver ranking', onPressed: () => Navigator.pushNamed(context, AppRoutes.ranking)),
      const SizedBox(height: 12),
      EhButton(label: 'Tentar outro quiz', secondary: true, onPressed: () => Navigator.pushNamed(context, AppRoutes.quizHub)),
    ]);
  }
}
