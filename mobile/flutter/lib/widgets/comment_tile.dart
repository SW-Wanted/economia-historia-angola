import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: comment.isAuthor ? AppColors.surfaceLow : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceContainer,
                child: Text(comment.initials,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(comment.author, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14))),
                        if (comment.role != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(6)),
                            child: Text(comment.role!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                          ),
                        ],
                      ],
                    ),
                    Text(comment.timeAgo, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment.text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 16, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text('${comment.likes}', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              const SizedBox(width: 16),
              const Icon(Icons.reply, size: 16, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text('Responder', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              const Spacer(),
              const Icon(Icons.flag_outlined, size: 16, color: AppColors.secondary),
            ],
          ),
        ],
      ),
    );
  }
}
