import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'eh_card.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return EhCard(
      child: Column(children: [
        Icon(icon, size: 48, color: AppColors.primary),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary), textAlign: TextAlign.center),
      ]),
    );
  }
}
