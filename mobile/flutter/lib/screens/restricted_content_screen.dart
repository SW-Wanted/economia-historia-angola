import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class RestrictedContentScreen extends StatelessWidget {
  const RestrictedContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Conteúdo restrito', showBack: true, children: [
      EhCard(
        color: AppColors.primary,
        child: Column(children: [
          const Icon(Icons.lock, color: Colors.white, size: 56),
          const SizedBox(height: 16),
          Text('Textos Jindungo', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text('Análises profundas, fontes selecionadas e leitura premium para membros.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .84)), textAlign: TextAlign.center),
        ]),
      ),
      const SizedBox(height: 24),
      EhButton(label: 'Subscrever agora', icon: Icons.workspace_premium_outlined, onPressed: () => Navigator.pushNamed(context, AppRoutes.subscription)),
      const SizedBox(height: 12),
      EhButton(label: 'Ver demonstracao', secondary: true, onPressed: () => Navigator.pushNamed(context, AppRoutes.unlockedText)),
    ]);
  }
}
