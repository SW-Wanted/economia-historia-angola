import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/article_draft.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key, this.unlocked = false});

  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    // Se vier um artigo recém-criado, o ecrã reflete o que foi introduzido.
    final draft = ModalRoute.of(context)?.settings.arguments;
    if (draft is ArticleDraft) return _draftView(context, draft);
    return _mockView(context);
  }

  // -------------------------------------- Artigo criado (reflete a criação)

  Widget _draftView(BuildContext context, ArticleDraft d) {
    final restricted = d.jindungo || d.exclusive;
    return ScreenFrame(title: d.typeLabel, showBack: true, children: [
      Text(d.title, style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 4, children: [
        Chip(label: Text(d.category), backgroundColor: AppColors.surfaceContainer),
        Chip(label: Text('${d.minutes} min')),
        if (d.community != null) Chip(label: Text('eh/${d.community!.replaceAll(' ', '')}'), backgroundColor: AppColors.surfaceLow),
        if (restricted) Chip(avatar: const Icon(Icons.lock_outline, size: 16, color: AppColors.primary), label: Text(d.jindungo ? 'Jindungo' : 'Exclusivo'), backgroundColor: AppColors.primaryFixed),
      ]),
      const SizedBox(height: 22),
      EhCard(
        child: Text(
          d.body.trim().isEmpty ? 'Sem conteúdo.' : d.body.trim(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.text, height: 1.7),
        ),
      ),
      if (d.source.trim().isNotEmpty) ...[
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.menu_book_outlined, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(child: Text('Fonte: ${d.source.trim()}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary))),
        ]),
      ],
      const SizedBox(height: 18),
      _discussionCard(context, private: d.privateRoom),
    ]);
  }

  // ------------------------------------------------------- Conteúdo demonstrativo

  Widget _mockView(BuildContext context) {
    return ScreenFrame(title: unlocked ? 'Texto desbloqueado' : 'Artigo', showBack: true, children: [
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
              ? 'Conteúdo exclusivo desbloqueado. A economia petrolífera angolana mostra como recursos naturais, instituições e escolhas públicas se encontram. O desafio central e transformar renda em capacidade produtiva duradoura.'
              : 'O Kwanza e mais do que uma unidade monetaria: e um simbolo de soberania. Entender a sua história ajuda a perceber inflacao, cambio, salarios e poder de compra no quotidiano angolano.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: unlocked ? Colors.white : AppColors.text, height: 1.7),
        ),
      ),
      const SizedBox(height: 18),
      Text('Pontos-chave', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 10),
      const _Bullet('Moeda, Estado e confianca estao profundamente ligados.'),
      const _Bullet('Politica cambial afeta precos, comercio e investimento.'),
      const _Bullet('A memória histórica ajuda a ler problemas atuais.'),
      const SizedBox(height: 16),
      _discussionCard(context, private: false),
    ]);
  }

  Widget _discussionCard(BuildContext context, {required bool private}) {
    return EhCard(
      onTap: () => Navigator.pushNamed(context, '/discussion-room'),
      color: AppColors.surfaceLow,
      child: Row(children: [
        Icon(private ? Icons.school_outlined : Icons.chat_bubble_outline, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(private ? 'Sala privada (turma)' : 'Sala de Discussão', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          Text(private ? 'Reservada aos estudantes admitidos.' : 'Debata este tema com a turma.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ])),
        const Icon(Icons.chevron_right, color: AppColors.outline),
      ]),
    );
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
