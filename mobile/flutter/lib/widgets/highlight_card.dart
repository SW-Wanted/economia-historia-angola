import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'eh_illustration.dart';

/// Card de destaque: ilustração com etiqueta sobreposta e chamada "Ler artigo".
/// Partilhado entre a Home e o Landing para manter consistência visual.
class HighlightCard extends StatelessWidget {
  const HighlightCard({super.key, required this.tag, required this.title, required this.scene, required this.onTap});

  final String tag;
  final String title;
  final EhScene scene;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ilustração com tag sobreposta e leve gradiente para contraste.
                  Stack(
                    children: [
                      EhIllustration(scene: scene, height: 96, borderRadius: BorderRadius.zero),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: .18)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .15), blurRadius: 5, offset: const Offset(0, 2))],
                          ),
                          child: Text(tag.toUpperCase(),
                              style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .8)),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.5, height: 1.25)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.menu_book_outlined, size: 14, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text('Ler artigo',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                              const Spacer(),
                              const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
