import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/notification_item.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item, this.onTap});

  final NotificationItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.unread ? AppColors.surfaceLow : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(item.body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: 6),
                    Text(item.timeAgo, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
              if (item.unread)
                Container(width: 9, height: 9, margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
            ],
          ),
        ),
      ),
    );
  }
}
