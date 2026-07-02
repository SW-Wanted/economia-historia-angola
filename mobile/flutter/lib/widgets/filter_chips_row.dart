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
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = i == selected;
          // Mesmo estilo dos filtros do Explorar/Fórum, para consistência visual.
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: active ? AppColors.navy : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: active ? AppColors.navy : AppColors.outlineVariant.withValues(alpha: .6)),
              ),
              child: Text(
                labels[i],
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      color: active ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
