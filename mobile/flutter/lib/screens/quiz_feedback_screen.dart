import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuizFeedbackScreen extends StatelessWidget {
  const QuizFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final q = const MockDataService().questions().first;
    return ScreenFrame(title: 'Feedback', showBack: true, children: [
      EhCard(
        color: AppColors.success.withValues(alpha: .08),
        child: Column(children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 64),
          const SizedBox(height: 12),
          Text('Resposta correta', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 10),
          Text(q.explanation, textAlign: TextAlign.center),
        ]),
      ),
      const SizedBox(height: 24),
      EhButton(label: 'Proxima pergunta', onPressed: () => Navigator.pushNamed(context, AppRoutes.quizResult)),
    ]);
  }
}
