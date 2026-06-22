import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key, this.unlocked = false});

  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: unlocked ? 'Texto desbloqueado' : 'Microtexto', showBack: true, children: [
      Text(unlocked ? 'Petroleo, renda e futuro' : 'Fundamentos: O que e o Kwanza?', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 10),
      Wrap(spacing: 8, children: [
        Chip(label: Text(unlocked ? 'Jindungo' : 'Essencial'), backgroundColor: unlocked ? AppColors.primaryFixed : AppColors.surfaceContainer),
        const Chip(label: Text('5 min')),
      ]),
      const SizedBox(height: 22),
      EhCard(
        color: unlocked ? AppColors.primary : AppColors.surface,
        child: Text(
          unlocked
              ? 'Conteudo exclusivo desbloqueado. A economia petrolifera angolana mostra como recursos naturais, instituicoes e escolhas publicas se encontram. O desafio central e transformar renda em capacidade produtiva duradoura.'
              : 'O Kwanza e mais do que uma unidade monetaria: e um simbolo de soberania. Entender a sua historia ajuda a perceber inflacao, cambio, salarios e poder de compra no quotidiano angolano.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: unlocked ? Colors.white : AppColors.text, height: 1.7),
        ),
      ),
      const SizedBox(height: 18),
      Text('Pontos-chave', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 10),
      const _Bullet('Moeda, Estado e confianca estao profundamente ligados.'),
      const _Bullet('Politica cambial afeta precos, comercio e investimento.'),
      const _Bullet('A memoria historica ajuda a ler problemas atuais.'),
      const SizedBox(height: 16),
      EhCard(
        onTap: () => Navigator.pushNamed(context, '/discussion-room'),
        color: AppColors.surfaceLow,
        child: Row(children: [
          const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sala de Discussao', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
            Text('Debata este tema com a turma.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ]),
      ),
    ]);
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ]),
      );
}
