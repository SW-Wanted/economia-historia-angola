import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/content_item.dart';
import 'eh_card.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.item, this.onTap});

  final ContentItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (item.locked) {
      return EhCard(
        onTap: onTap,
        color: AppColors.primary,
        child: Stack(
          children: [
            Positioned(right: -12, bottom: -18, child: Icon(Icons.local_fire_department, size: 104, color: Colors.white.withValues(alpha: .12))),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.bolt, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontStyle: FontStyle.italic))),
                const Icon(Icons.lock, color: Colors.white),
              ]),
              const SizedBox(height: 12),
              Text(item.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .88), fontStyle: FontStyle.italic)),
            ]),
          ],
        ),
      );
    }
    return EhCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(16)),
            child: Icon(item.icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
              const SizedBox(height: 4),
              Text('${item.category} • ${item.minutes} min de leitura', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              const SizedBox(height: 6),
              Text(item.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}
