import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.title = 'Economia com Historia', this.showBack = false});

  final String title;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60,
      leading: showBack
          ? IconButton(onPressed: () => Navigator.maybePop(context), icon: const Icon(Icons.arrow_back))
          : Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: .12),
                child: const Text('M', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
              ),
            ),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 17)),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          icon: const Icon(Icons.notifications_none),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
