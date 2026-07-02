import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/screen_frame.dart';

/// Aprovação de conteúdos submetidos por Escritores (Admin+).
class ContentModerationScreen extends StatefulWidget {
  const ContentModerationScreen({super.key});

  @override
  State<ContentModerationScreen> createState() => _ContentModerationScreenState();
}

class _ContentModerationScreenState extends State<ContentModerationScreen> {
  late final List<_Pending> _items = [
    const _Pending('O ciclo do café no Uíge', 'Dr. Kambinda', 'Artigo', EhScene.market),
    const _Pending('Reformas monetárias: 1990–1999', 'Ana Muachia', 'Artigo', EhScene.currency),
    const _Pending('Conversas de Economia · Ep. 5', 'Dr. Kambinda', 'Podcast', EhScene.podcast),
  ];

  void _decide(int i, bool approve) {
    final name = _items[i].title;
    setState(() => _items.removeAt(i));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(approve ? '"$name" aprovado e publicado.' : '"$name" devolvido ao autor.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Aprovação de Conteúdos', showBack: true, children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.navy.withValues(alpha: .2)),
        ),
        child: Row(children: [
          const Icon(Icons.fact_check_outlined, color: AppColors.navy, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Conteúdos submetidos por Escritores aguardam a sua aprovação.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy)),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      if (_items.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Center(
            child: Column(children: [
              const Icon(Icons.inbox_outlined, size: 56, color: AppColors.outline),
              const SizedBox(height: 12),
              Text('Sem conteúdos pendentes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            ]),
          ),
        ),
      for (var i = 0; i < _items.length; i++) ...[
        _card(context, i),
        const SizedBox(height: 14),
      ],
    ]);
  }

  Widget _card(BuildContext context, int i) {
    final item = _items[i];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            EhIllustration(scene: item.scene, height: 120),
            Positioned(
              left: 12, top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                child: Text(item.type.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text('por ${item.author}', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _decide(i, false),
                      icon: const Icon(Icons.close),
                      label: const Text('Devolver'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _decide(i, true),
                      icon: const Icon(Icons.check),
                      label: const Text('Aprovar'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pending {
  const _Pending(this.title, this.author, this.type, this.scene);
  final String title;
  final String author;
  final String type;
  final EhScene scene;
}
