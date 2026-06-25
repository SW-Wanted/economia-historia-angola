import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Linha de chips de filtro com estado ativo (Navy) / inativo.
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = i == selected;
          return ChoiceChip(
            label: Text(labels[i]),
            selected: active,
            onSelected: (_) => onSelected(i),
            showCheckmark: false,
            labelStyle: TextStyle(
              color: active ? Colors.white : AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.navy,
            side: BorderSide(color: active ? AppColors.navy : AppColors.outlineVariant),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          );
        },
      ),
    );
  }
}
