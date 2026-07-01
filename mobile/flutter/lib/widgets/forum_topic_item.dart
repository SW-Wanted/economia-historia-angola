import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/forum_topic.dart';
import 'eh_card.dart';

class ForumTopicItem extends StatelessWidget {
  const ForumTopicItem({super.key, required this.topic, this.onTap});

  final ForumTopic topic;
  final VoidCallback? onTap;

  // Paleta de acentos por etiqueta (determinística, dentro do Design System).
  static const _accents = [AppColors.primary, AppColors.navy, AppColors.tertiary, AppColors.success];

  Color get _accent => _accents[topic.tag.hashCode.abs() % _accents.length];

  String get _initials {
    final parts = topic.author.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    return EhCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tagPill(topic.tag, accent),
              if (topic.pinned) ...[
                const SizedBox(width: 8),
                const Icon(Icons.push_pin, size: 15, color: AppColors.tertiary),
              ],
              const Spacer(),
              Icon(topic.private ? Icons.lock : Icons.chevron_right, color: topic.private ? AppColors.secondary : accent, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(topic.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, height: 1.25)),
          if (topic.excerpt.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(topic.excerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.4)),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: accent.withValues(alpha: .14),
                child: Text(_initials, style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.author, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text('${topic.role} • ${topic.timeAgo}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.mode_comment_outlined, size: 15, color: AppColors.secondary),
              const SizedBox(width: 5),
              Text('${topic.comments}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagPill(String tag, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(tag.toUpperCase(),
          style: TextStyle(color: accent, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: .6)),
    );
  }
}
