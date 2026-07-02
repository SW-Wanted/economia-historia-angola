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
    final args = ModalRoute.of(context)?.settings.arguments;
    final score = (args is Map && args['score'] is int) ? args['score'] as int : 8;
    final total = (args is Map && args['total'] is int) ? args['total'] as int : 10;
    final pct = total == 0 ? 0 : (score / total * 100).round();

    final (title, message) = switch (pct) {
      >= 80 => ('Excelente!', 'Domínio sólido do tema. Continue a explorar os textos com Jindungo para aprofundar.'),
      >= 50 => ('Bom trabalho!', 'Vai no bom caminho. Reveja os artigos da categoria para reforçar os conceitos.'),
      _ => ('Continue a praticar', 'Sugerimos rever os conteúdos do módulo antes de tentar de novo. Cada tentativa conta.'),
    };

    return ScreenFrame(title: 'Resultado do Quiz', showBack: true, children: [
      EhCard(
        child: Column(children: [
          Icon(pct >= 50 ? Icons.emoji_events : Icons.school_outlined, color: AppColors.warning, size: 76),
          const SizedBox(height: 10),
          Text('$score/$total', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary, fontSize: 44)),
          Text('$pct% de acerto', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
        ]),
      ),
      const SizedBox(height: 16),

      // Avaliação formativa: o que rever
      EhCard(
        color: AppColors.surfaceLow,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: const [
            Icon(Icons.menu_book_outlined, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Sugestões de estudo', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          _tip(context, 'Reveja "O ciclo do café em Angola"'),
          _tip(context, 'Leia o artigo sobre o Kwanza'),
          _tip(context, 'Explore o mapa interativo da sua província'),
        ]),
      ),
      const SizedBox(height: 24),
      EhButton(label: 'Ver ranking', onPressed: () => Navigator.pushNamed(context, AppRoutes.ranking)),
      const SizedBox(height: 12),
      EhButton(label: 'Tentar outro quiz', secondary: true, onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.quizHub, (r) => r.settings.name == AppRoutes.dashboard || r.isFirst)),
    ]);
  }

  Widget _tip(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.arrow_right, color: AppColors.primary, size: 20),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ]),
      );
}
