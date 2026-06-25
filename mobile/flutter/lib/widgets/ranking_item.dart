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
    final me = user.isCurrentUser;
    return EhCard(
      onTap: onTap,
      color: me ? AppColors.surfaceContainer : AppColors.surface,
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              position.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: podium ? AppColors.primary : AppColors.primary.withValues(alpha: .25),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: me ? AppColors.primary : AppColors.surfaceContainer,
            child: Text(user.initials,
                style: TextStyle(color: me ? Colors.white : AppColors.primary, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16))),
                    if (me) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Você', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                Text('${user.level} • ${user.institution}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                if (user.badges.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final b in user.badges)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(6)),
                          child: Text(b, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${user.points}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              _trend(user.trend),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trend(int t) {
    if (t == 0) {
      return const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.remove, size: 14, color: AppColors.secondary),
        Text('0', style: TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.w700)),
      ]);
    }
    final up = t > 0;
    final color = up ? AppColors.success : AppColors.error;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(up ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 18, color: color),
      Text('${t.abs()}', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    ]);
  }
}
