import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../providers/app_state.dart';
import '../services/mock_data_service.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final q = const MockDataService().questions().first;
    final selected = AppStateScope.of(context).quizAnswer;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pergunta 2 de 10', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                          const SizedBox(height: 4),
                          Container(
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4)),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.2,
                              child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Timer Circular
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 2,
                          backgroundColor: AppColors.outlineVariant,
                          color: AppColors.primary,
                        ),
                        Text('30s', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Illustration / Context
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant),
                        image: const DecorationImage(
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCVHpGaCDHWuVTjL_yyafh0GBiP8OY_fZgW63Bfqmvhdqwugw6vUMo1ztfUA00zfyGOjcePYI--ex0vjwEyS8elIcapsT8OaPri5VjBJjbt5Zg15pe2LWXnsERwWkM17wE3pl3z8sS61VZ2MSumoclWBxRXXouNf0J01G0mdUGiAhfmNr9jopv2lzNPc1j4dJD7JjkOm0v27NN_0YztZrVT_Q8qs4Es2bVznA26RX1tNlgxL9hxuMyU-luwZU3Q3VOA36RFW-MB6ds'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Question Title
                    Text(
                      q.question,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                    const SizedBox(height: 24),
                    
                    // Options List
                    ...List.generate(q.options.length, (i) {
                      final isSelected = selected == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () => AppStateScope.of(context, listen: false).selectQuizAnswer(i),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.outlineVariant),
                              boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(String.fromCharCode(65 + i), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 16),
                                Expanded(child: Text(q.options[i], style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant))),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    
                    // Heritage Insight (Jindungo Card)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B1A1A), // Bordeaux
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryContainer),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bolt, color: Colors.yellow, size: 20),
                              const SizedBox(width: 8),
                              Text('DICA HISTÓRICA', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A reforma de 1999 foi um marco crucial para estabilizar a inflação galopante que assolava a economia angolana no final do século XX.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // Space for footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
        ),
        child: ElevatedButton(
          onPressed: selected >= 0 ? () => Navigator.pushNamed(context, AppRoutes.quizFeedback) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.secondaryFixedDim,
            disabledForegroundColor: AppColors.onSecondaryFixedVariant,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
