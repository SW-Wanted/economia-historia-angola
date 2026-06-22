import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Cartão "Texto com Jindungo": fundo bordeaux escuro, texto itálico e ícone ⚡.
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.warning, size: 22),
                  const SizedBox(width: 8),
                  Text('TEXTOS COM JINDUNGO',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (locked) const Icon(Icons.lock_outline, color: Colors.white70, size: 18),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                quote,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white, fontStyle: FontStyle.italic, fontSize: 17, height: 1.4),
              ),
              if (source != null) ...[
                const SizedBox(height: 10),
                Text('— $source',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ],
              const SizedBox(height: 16),
              Divider(color: Colors.white.withValues(alpha: .2), height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      locked ? 'Exclusivo para membros' : 'Conteudo desbloqueado',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                  ),
                  if (onAction != null)
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: Text(actionLabel,
                          style: const TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.underline)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
