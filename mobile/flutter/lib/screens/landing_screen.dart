import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/section_title.dart';
import '../widgets/screen_frame.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Economia com Historia', children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(children: [
          Positioned(right: -24, bottom: -28, child: Icon(Icons.history_edu, size: 160, color: Colors.white.withValues(alpha: .1))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Aprenda a economia de Angola pela sua historia', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 22),
            EhButton(label: 'Comecar agora', inverted: true, fullWidth: false, onPressed: () => Navigator.pushNamed(context, AppRoutes.register1)),
          ]),
        ]),
      ),
      const SizedBox(height: 32),
      const SectionTitle('O que e?'),
      const SizedBox(height: 14),
      Text('Uma plataforma dedicada a desvendar os fios que tecem a realidade economica angolana, desde as suas raizes historicas ate aos desafios contemporaneos.', style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _MiniValue(icon: Icons.school_outlined, label: 'Rigor academico')),
        const SizedBox(width: 12),
        Expanded(child: _MiniValue(icon: Icons.auto_stories_outlined, label: 'Heranca cultural')),
      ]),
      const SizedBox(height: 32),
      const SectionTitle('O que vai encontrar?'),
      const SizedBox(height: 16),
      _Feature(icon: Icons.article_outlined, title: 'Microtextos', text: 'Pilulas de conhecimento rapido sobre eventos economicos cruciais.'),
      const SizedBox(height: 12),
      _JindungoPreview(onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent)),
      const SizedBox(height: 12),
      _Feature(icon: Icons.quiz_outlined, title: 'Quiz', text: 'Teste os seus conhecimentos e aprenda de forma interativa.'),
      const SizedBox(height: 32),
      EhButton(label: 'Entrar', onPressed: () => Navigator.pushNamed(context, AppRoutes.login)),
    ]);
  }
}

class _MiniValue extends StatelessWidget {
  const _MiniValue({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => EhCard(
        color: AppColors.surfaceLow,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ]),
      );
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => EhCard(
        child: Row(children: [
          CircleAvatar(backgroundColor: AppColors.surfaceContainer, child: Icon(icon, color: AppColors.primary)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          ])),
        ]),
      );
}

class _JindungoPreview extends StatelessWidget {
  const _JindungoPreview({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => EhCard(
        onTap: onTap,
        color: AppColors.primary,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.bolt, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Textos Jindungo', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontStyle: FontStyle.italic))),
            const Icon(Icons.lock, color: Colors.white),
          ]),
          const SizedBox(height: 12),
          Text('Analises profundas e picantes sobre a nossa heranca economica.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .88), fontStyle: FontStyle.italic)),
        ]),
      );
}
