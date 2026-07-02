import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Cartão "Texto com Jindungo": conteúdo premium/exclusivo, com fundo bordeaux
/// em gradiente, acentos dourados e um apelo claro à subscrição.
class JindungoCard extends StatelessWidget {
  const JindungoCard({
    super.key,
    required this.quote,
    this.source,
    this.locked = true,
    this.actionLabel = 'Assinar',
    this.onAction,
    this.onTap,
  });

  final String quote;
  final String? source;
  final bool locked;
  final String actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;

  // Tom dourado quente para os acentos premium.
  static const _gold = AppColors.warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: .35), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Fundo em gradiente bordeaux.
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
              ),
            ),
            // Marca de água: raio dourado esbatido.
            Positioned(
              right: -24,
              top: -18,
              child: Icon(Icons.local_fire_department, size: 150, color: _gold.withValues(alpha: .12)),
            ),
            // Brilho subtil no topo.
            Positioned(
              left: -40,
              top: -60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .05),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _topRow(context),
                      const SizedBox(height: 16),
                      // Aspas decorativas + citação.
                      Icon(Icons.format_quote, color: _gold.withValues(alpha: .85), size: 26),
                      const SizedBox(height: 4),
                      Text(
                        quote,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (source != null) ...[
                        const SizedBox(height: 10),
                        Text('— $source',
                            style: const TextStyle(
                                color: AppColors.tertiaryFixed, fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                      const SizedBox(height: 16),
                      _enticer(context),
                      const SizedBox(height: 14),
                      _cta(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topRow(BuildContext context) {
    return Row(
      children: [
        // Selo premium dourado.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _gold.withValues(alpha: .18),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: _gold.withValues(alpha: .45)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department, color: _gold, size: 15),
              const SizedBox(width: 6),
              const Text('TEXTOS COM JINDUNGO',
                  style: TextStyle(
                      color: AppColors.tertiaryFixed,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w800,
                      fontSize: 11)),
            ],
          ),
        ),
        const Spacer(),
        if (locked)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), shape: BoxShape.circle),
            child: const Icon(Icons.lock_outline, color: Colors.white, size: 16),
          ),
      ],
    );
  }

  Widget _enticer(BuildContext context) {
    final text = locked
        ? 'Análise completa, contexto histórico e áudio — só para membros.'
        : 'Conteúdo desbloqueado. Bom proveito!';
    return Row(
      children: [
        Icon(locked ? Icons.auto_awesome : Icons.check_circle, color: _gold, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(color: Colors.white.withValues(alpha: .85), fontSize: 12.5, height: 1.35)),
        ),
      ],
    );
  }

  Widget _cta(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onAction ?? onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .3),
        ),
        icon: Icon(locked ? Icons.lock_open_rounded : Icons.menu_book_rounded, size: 18),
        label: Text(locked ? '$actionLabel — Desbloquear agora' : actionLabel),
      ),
    );
  }
}
