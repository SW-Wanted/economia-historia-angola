import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(99))),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary))),
        ?action,
      ],
    );
  }
}
