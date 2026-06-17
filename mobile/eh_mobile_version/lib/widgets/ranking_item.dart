import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/ranking_user.dart';
import 'eh_card.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({super.key, required this.user, required this.position, this.onTap});

  final RankingUser user;
  final int position;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final podium = position <= 3;
    return EhCard(
      onTap: onTap,
      child: Row(
        children: [
          Text(position.toString().padLeft(2, '0'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: podium ? AppColors.primary : AppColors.primary.withValues(alpha: .25))),
          const SizedBox(width: 14),
          CircleAvatar(backgroundColor: AppColors.surfaceContainer, child: Text(user.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            Text(user.level, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ])),
          Text('${user.points}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
