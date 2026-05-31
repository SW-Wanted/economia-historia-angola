import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/forum_topic.dart';
import 'eh_card.dart';

class ForumTopicItem extends StatelessWidget {
  const ForumTopicItem({super.key, required this.topic, this.onTap});

  final ForumTopic topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return EhCard(
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(topic.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16))),
          Icon(topic.private ? Icons.lock : Icons.chevron_right, color: AppColors.primary),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          Chip(label: Text(topic.tag), visualDensity: VisualDensity.compact, backgroundColor: AppColors.surfaceContainer),
          Chip(label: Text('${topic.comments} comentarios'), visualDensity: VisualDensity.compact),
        ]),
        const SizedBox(height: 8),
        Text('Iniciado por ${topic.author}', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]),
    );
  }
}
