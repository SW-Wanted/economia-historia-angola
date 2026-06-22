import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class PublishConfirmationScreen extends StatelessWidget {
  const PublishConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 110, height: 110,
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: .12), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
          ),
        ),
        const SizedBox(height: 24),
        Text('Conteudo publicado!', textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
        const SizedBox(height: 10),
        Text(
          'O seu conteudo ja esta disponivel para a comunidade. Pode acompanhar o desempenho no painel.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
        ),
        const SizedBox(height: 32),
        EhButton(
          label: 'Ver no painel',
          icon: Icons.dashboard_outlined,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.adminPanel, (r) => r.isFirst),
        ),
        const SizedBox(height: 12),
        EhButton(
          label: 'Publicar outro',
          secondary: true,
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.publishContent),
        ),
      ],
    );
  }
}
