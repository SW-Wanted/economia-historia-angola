import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/forum_topic.dart';

class ForumTopicItem extends StatelessWidget {
  const ForumTopicItem({super.key, required this.topic, this.onTap});

  final ForumTopic topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: topic.isPinned
            ? const Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(color: AppColors.outlineVariant, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        topic.author.isNotEmpty ? topic.author[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (topic.authorRole == 'Professor') ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'PROFESSOR',
                                    style: TextStyle(
                                      color: AppColors.onSecondaryContainer,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                topic.timeAgo,
                                style: const TextStyle(
                                  color: AppColors.outline,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              if (topic.isPinned)
                                const Icon(
                                  Icons.push_pin,
                                  color: AppColors.primary,
                                  size: 18,
                                )
                              else if (topic.private)
                                const Icon(
                                  Icons.lock,
                                  color: AppColors.outline,
                                  size: 18,
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            topic.title,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: topic.isPinned ? AppColors.primary : AppColors.onSurface,
                              height: 1.3,
                            ),
                          ),
                          if (topic.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              topic.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          // Category and answers
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                                ),
                                child: Text(
                                  topic.tag,
                                  style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.forum_outlined,
                                    color: AppColors.outline,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${topic.comments} respostas',
                                    style: const TextStyle(
                                      color: AppColors.outline,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

