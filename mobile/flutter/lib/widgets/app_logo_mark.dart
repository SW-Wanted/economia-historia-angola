import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Marca/ícone oficial da aplicação: quadrado branco arredondado com o ícone
/// `history_edu` na cor primária. É o elemento de identidade partilhado pelo
/// cabeçalho, splash e pela animação de carregamento ([AppLoadingIndicator]).
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 32,
    this.background = Colors.white,
    this.iconColor = AppColors.primary,
    this.elevation = 0,
  });

  /// Lado do quadrado.
  final double size;
  final Color background;
  final Color iconColor;

  /// Sombra opcional (usada na animação de loading para dar profundidade).
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.28;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: elevation <= 0
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .18),
                  blurRadius: elevation,
                  offset: Offset(0, elevation * .35),
                ),
              ],
      ),
      child: Icon(Icons.history_edu, color: iconColor, size: size * 0.56),
    );
  }
}
