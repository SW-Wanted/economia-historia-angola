import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../providers/app_state.dart';
import '../services/mock_data_service.dart';

class QuizFeedbackScreen extends StatelessWidget {
  const QuizFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final q = const MockDataService().questions().first;
    final selected = AppStateScope.of(context).quizAnswer;
    const correctAnswerIndex = 1; // Mock correct answer for demonstration

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: const Color(0x0D000000),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Economia com História', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDd0d5Fvd65sfT0v58lfmQsUqaA_JpnqzWE8tua1Wd4yi-CmC6fG2WabjSnW_N63ZMIJN5hL9mb_rrLn-JATGQNNAWQaVUpd6T9W0YgqjC1cyvQC2-ZSck5Goxaas-Mx5GVlGet257AZYH7poaQYqyGRGfpk9MNF-kp3qnbhRMzBPGAXbj1MA9naRIwbbiKNWMsxPR0BVqHwYKUjJ3dBRMoJ7cv3RvpH58c6ot4BWWa9UNyE1brsxoLKHjxH-hA6QYc0UldtNiM1LY'),
              backgroundColor: AppColors.surfaceContainer,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Title
            Text('Pergunta 1 de 10', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: 1.0)),
            const SizedBox(height: 8),
            Text(
              q.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const SizedBox(height: 32),

            // Options Container
            ...List.generate(q.options.length, (i) {
              final isCorrect = i == correctAnswerIndex;
              final isSelected = selected == i;

              Color bgColor;
              Color borderColor;
              Color textColor;
              IconData? iconData;
              Color? iconColor;

              if (isCorrect) {
                bgColor = AppColors.success.withValues(alpha: 0.15); // Success container
                borderColor = AppColors.success.withValues(alpha: 0.3);
                textColor = AppColors.success;
                iconData = Icons.check_circle;
                iconColor = AppColors.success;
              } else if (isSelected && !isCorrect) {
                bgColor = AppColors.errorContainer;
                borderColor = AppColors.error;
                textColor = AppColors.onErrorContainer;
                iconData = Icons.cancel;
                iconColor = AppColors.error;
              } else {
                bgColor = AppColors.surfaceContainerLowest;
                borderColor = AppColors.outlineVariant;
                textColor = AppColors.secondary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: isCorrect || isSelected ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      if (iconData != null)
                        Icon(iconData, color: iconColor)
                      else
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.outlineVariant, width: 2)),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          q.options[i],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: textColor.withValues(alpha: (!isCorrect && !isSelected) ? 0.6 : 1.0),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Explanation Card (Contexto Histórico)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryFixed),
                boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history_edu, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Contexto Histórico', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    q.explanation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant, fontStyle: FontStyle.italic, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.quizResult),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Próxima pergunta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Ver discussão no Fórum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
