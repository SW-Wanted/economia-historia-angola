import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuizHubScreen extends StatelessWidget {
  const QuizHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Quiz Hub',
      showBack: true,
      children: [
        EhCard(
          color: AppColors.primary,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.timer_outlined, color: Colors.white),
            const SizedBox(height: 12),
            Text('Quiz: O Ciclo do Café', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 10),
            Text('Teste seus conhecimentos sobre uma das principais exportações históricas de Angola.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .86))),
            const SizedBox(height: 20),
            EhButton(label: 'Participar agora', inverted: true, fullWidth: false, onPressed: () => Navigator.pushNamed(context, AppRoutes.quizQuestion)),
          ]),
        ),
        const SizedBox(height: 20),
        const _Stat(label: 'Pontuacao media', value: '74%'),
        const SizedBox(height: 12),
        const _Stat(label: 'Participantes da semana', value: '1.284'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => EhCard(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 20))]));
}
