import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class RankingDetailScreen extends StatelessWidget {
  const RankingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Detalhe do ranking', showBack: true, children: [
      EhCard(child: Column(children: [
        const CircleAvatar(radius: 38, backgroundColor: AppColors.surfaceContainer, child: Text('MK', style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w900))),
        const SizedBox(height: 12),
        Text('Manuel Kiala', style: Theme.of(context).textTheme.headlineMedium),
        const Text('Mestre Jindungo • 980 pontos'),
      ])),
      const SizedBox(height: 18),
      const EhCard(child: Text('Conquistas: 12 quizzes completos, 8 leituras premium, 4 topicos criados no forum.')),
    ]);
  }
}
