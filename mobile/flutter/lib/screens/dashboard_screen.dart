import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/content_card.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/section_title.dart';
import '../widgets/screen_frame.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contents = const MockDataService().contents();
    return BottomNavShell(
      index: 0,
      child: ScreenFrame(title: 'Economia com Historia', paddingBottom: 96, children: [
        Text('Ola, Manuel', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        EhCard(
          color: AppColors.primary.withValues(alpha: .08),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bem-vindo ao Jindungo', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            const Text('Novo por aqui? Criamos um guia rapido para ajudar a explorar a historia economica de Angola.'),
            const SizedBox(height: 14),
            EhButton(label: 'Ver guia de inicio', icon: Icons.auto_stories_outlined, fullWidth: false, onPressed: () => Navigator.pushNamed(context, AppRoutes.quickStart)),
          ]),
        ),
        const SizedBox(height: 30),
        const SectionTitle('Sugestoes para ti'),
        const SizedBox(height: 14),
        ContentCard(item: contents.first, onTap: () => Navigator.pushNamed(context, AppRoutes.reading)),
        const SizedBox(height: 30),
        const SectionTitle('Novidades do Jindungo'),
        const SizedBox(height: 14),
        ContentCard(item: contents.last, onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent)),
        const SizedBox(height: 30),
        const SectionTitle('O que podes fazer'),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
          children: [
            _ActionTile(icon: Icons.menu_book_outlined, title: 'Leitura', onTap: () => Navigator.pushNamed(context, AppRoutes.explore)),
            _ActionTile(icon: Icons.quiz_outlined, title: 'Quizzes', onTap: () => Navigator.pushNamed(context, AppRoutes.quizHub)),
            _ActionTile(icon: Icons.map_outlined, title: 'Mapa', onTap: () => Navigator.pushNamed(context, AppRoutes.map)),
            _ActionTile(icon: Icons.forum_outlined, title: 'Forum', onTap: () => Navigator.pushNamed(context, AppRoutes.forum)),
          ],
        ),
        const SizedBox(height: 30),
        EhCard(
          color: AppColors.surfaceLow,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.lightbulb_outline, color: AppColors.primary), const SizedBox(width: 8), Text('Sabia que?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary))]),
            const SizedBox(height: 10),
            const Text('Na decada de 1970, Angola chegou a ser o quarto maior produtor mundial de cafe.'),
          ]),
        ),
      ]),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => EhCard(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: AppColors.primary)),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
        ]),
      );
}
