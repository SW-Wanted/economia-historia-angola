import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

/// FAQ pública — acessível a utilizadores não autenticados (decisão de sala).
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faq = const MockDataService().faq();
    return ScreenFrame(
      title: 'Perguntas Frequentes',
      showBack: true,
      children: [
        Text('Tudo o que precisa de saber',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Text('Respostas rapidas sobre a plataforma, conteudos e acesso.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 20),
        for (final entry in faq.entries) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                iconColor: AppColors.primary,
                collapsedIconColor: AppColors.secondary,
                title: Text(entry.key, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(entry.value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.5)),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const Icon(Icons.help_outline, color: AppColors.primary, size: 30),
              const SizedBox(height: 10),
              Text('Ainda tem duvidas?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
              const SizedBox(height: 4),
              Text('Crie conta para participar e contactar a equipa.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
              const SizedBox(height: 14),
              EhButton(label: 'Criar conta', onPressed: () => Navigator.pushNamed(context, AppRoutes.register1)),
            ],
          ),
        ),
      ],
    );
  }
}
