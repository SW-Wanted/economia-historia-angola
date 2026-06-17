import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../providers/app_state.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final q = const MockDataService().questions().first;
    final selected = AppStateScope.of(context).quizAnswer;
    return ScreenFrame(title: 'Pergunta 1/10', showBack: true, children: [
      LinearProgressIndicator(value: .1, color: AppColors.primary, backgroundColor: AppColors.outlineVariant),
      const SizedBox(height: 24),
      Text(q.question, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 18),
      for (var i = 0; i < q.options.length; i++) ...[
        EhCard(
          color: selected == i ? AppColors.surfaceContainer : AppColors.surface,
          onTap: () => AppStateScope.of(context, listen: false).selectQuizAnswer(i),
          child: Row(children: [
            CircleAvatar(backgroundColor: selected == i ? AppColors.primary : AppColors.surfaceHighest, foregroundColor: selected == i ? Colors.white : AppColors.primary, child: Text(String.fromCharCode(65 + i))),
            const SizedBox(width: 14),
            Expanded(child: Text(q.options[i])),
          ]),
        ),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 16),
      EhButton(label: 'Confirmar', onPressed: () => Navigator.pushNamed(context, AppRoutes.quizFeedback)),
    ]);
  }
}
