import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/feed.dart';
import 'eh_illustration.dart';

/// Selo compacto que explica *porquê* um conteúdo foi recomendado.
/// Ex.: "Porque segue Economia Colonial", "Popular esta semana", "Novo".
class ReasonBadge extends StatelessWidget {
  const ReasonBadge({super.key, required this.entry, this.onLight = false});

  final FeedEntry entry;

  /// Quando `true`, adapta-se a fundos claros (usado sobre superfícies brancas).
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final color = entry.reason.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onLight ? color.withValues(alpha: .10) : Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: onLight ? Border.all(color: color.withValues(alpha: .30)) : null,
        boxShadow: onLight
            ? null
            : [BoxShadow(color: Colors.black.withValues(alpha: .12), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(entry.reason.icon, size: 12, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              entry.reasonLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: .2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Linha de métricas de interação (tempo de leitura, visualizações, comentários,
/// gostos) partilhada pelos cartões do feed.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.content, this.dense = false});

  final FeedContent content;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.secondary,
          fontSize: dense ? 11 : 11.5,
          fontWeight: FontWeight.w600,
        );
    Widget metric(IconData icon, String value) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: dense ? 12 : 13, color: AppColors.outline),
            const SizedBox(width: 3),
            Text(value, style: style),
          ],
        );

    return Wrap(
      spacing: dense ? 10 : 12,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        metric(Icons.schedule, '${content.minutes} min'),
        metric(Icons.visibility_outlined, formatCount(content.views)),
        if (content.comments > 0) metric(Icons.mode_comment_outlined, formatCount(content.comments)),
        metric(Icons.favorite_outline, formatCount(content.likes)),
      ],
    );
  }
}

/// Etiqueta de categoria sobreposta à capa (estilo do [HighlightCard]).
class _CategoryChip extends StatelessWidget {
  const _CategoryChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .15), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Text(label.toUpperCase(),
            style: const TextStyle(color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .6)),
      );
}

/// Cartão de conteúdo horizontal (carrosséis "Recomendado", "Tendências", …).
class FeedContentCard extends StatelessWidget {
  const FeedContentCard({super.key, required this.entry, required this.onTap, this.width = 264});

  final FeedEntry entry;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final c = entry.content;
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      EhIllustration(scene: c.scene, height: 116, borderRadius: BorderRadius.zero),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: .28)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(left: 10, top: 10, child: _CategoryChip(c.category)),
                      if (c.locked)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.black.withValues(alpha: .35), shape: BoxShape.circle),
                            child: const Icon(Icons.lock_outline, color: Colors.white, size: 14),
                          ),
                        ),
                      Positioned(left: 10, right: 10, bottom: 10, child: ReasonBadge(entry: entry)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                          child: Text(c.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.5, height: 1.25)),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(c.type.icon, size: 13, color: AppColors.primary),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(c.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.secondary, fontSize: 11.5, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _MetaRow(content: c, dense: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha de conteúdo em largura total (feed de descoberta / scroll infinito).
class FeedContentTile extends StatelessWidget {
  const FeedContentTile({super.key, required this.entry, required this.onTap});

  final FeedEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = entry.content;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      EhIllustration(scene: c.scene, width: 96, height: 96, borderRadius: BorderRadius.circular(14)),
                      if (c.locked)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.black.withValues(alpha: .35), shape: BoxShape.circle),
                            child: const Icon(Icons.lock_outline, color: Colors.white, size: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(alignment: Alignment.centerLeft, child: ReasonBadge(entry: entry, onLight: true)),
                        const SizedBox(height: 6),
                        Text(c.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.5, height: 1.2)),
                        const SizedBox(height: 4),
                        Text('${c.category} · ${relativePublished(c.publishedAt)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.secondary, fontSize: 11.5, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        _MetaRow(content: c, dense: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cartão "Continue a ler" com progresso e ação de continuar.
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key, required this.entry, required this.onTap, this.width = 300});

  final FeedEntry entry;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final c = entry.content;
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        EhIllustration(scene: c.scene, width: 60, height: 60, borderRadius: BorderRadius.circular(14)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.category.toUpperCase(),
                                  style: const TextStyle(
                                      color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .6)),
                              const SizedBox(height: 3),
                              Text(c.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14, height: 1.2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: c.readProgress,
                        minHeight: 7,
                        backgroundColor: AppColors.surfaceHighest,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${c.percent}% concluído',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('Continuar',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
