import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faq = const MockDataService().faq();
    return ScreenFrame(
      title: 'Central de Ajuda',
      showBack: true,
      children: [
        const TextField(decoration: InputDecoration(hintText: 'Pesquisar ajuda', prefixIcon: Icon(Icons.search))),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _quick(context, Icons.quiz_outlined, 'FAQ', () => Navigator.pushNamed(context, AppRoutes.faq))),
          const SizedBox(width: 12),
          Expanded(child: _quick(context, Icons.feedback_outlined, 'Sugestões', () => Navigator.pushNamed(context, AppRoutes.feedback))),
        ]),
        const SizedBox(height: 24),
        const SectionTitle('Perguntas frequentes'),
        const SizedBox(height: 12),
        for (final entry in faq.entries.take(4)) ...[
          EhCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.faq),
            child: Row(children: [
              Expanded(child: Text(entry.key, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15))),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ]),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        EhCard(
          color: AppColors.surfaceLow,
          child: Row(children: [
            const Icon(Icons.mail_outline, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text('carlos.lopes@isptec.co.ao', style: Theme.of(context).textTheme.bodyMedium)),
          ]),
        ),
      ],
    );
  }

  Widget _quick(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return EhCard(
      onTap: onTap,
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 26),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
      ]),
    );
  }
}
