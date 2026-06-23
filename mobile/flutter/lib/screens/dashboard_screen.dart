import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_card.dart';
import '../widgets/jindungo_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = const MockDataService();
    final user = data.currentUser();
    final resume = data.continueReading();
    final quiz = data.weeklyQuiz();
    final jindungo = data.featuredJindungo();
    return BottomNavShell(
      index: 0,
      child: ScreenFrame(
        title: 'Economia com Historia',
        paddingBottom: 96,
        children: [
          Row(
            children: [
              Text('Ola, ${user.name.split(' ').first}', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
              const SizedBox(width: 6),
              const Text('👋', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 20),

          // Continuar onde parou — cartão de progresso
          Text('Continuar onde parou', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          EhCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.reading),
            child: Row(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.payments_outlined, color: AppColors.primary, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(resume.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(resume.subtitle,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: resume.progress, minHeight: 7,
                          backgroundColor: AppColors.surfaceHighest,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${resume.percent}% concluido',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quiz da semana
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pushNamed(context, AppRoutes.quizHub),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Positioned(right: -6, top: -6, child: Icon(Icons.quiz, size: 86, color: Colors.white.withValues(alpha: .12))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quiz.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                        const SizedBox(height: 6),
                        Text(quiz.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.quizHub),
                          style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                          child: const Text('COMECAR AGORA'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Destaques
          SectionTitle('Destaques', action: TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.explore),
            child: const Text('Ver todos', style: TextStyle(color: AppColors.primary)),
          )),
          const SizedBox(height: 14),
          SizedBox(
            height: 184,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: data.highlights().length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final h = data.highlights()[i];
                return _Highlight(
                  tag: h.tag,
                  title: h.title,
                  icon: h.icon,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.reading),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Textos com Jindungo
          Row(children: [
            Text('Textos com Jindungo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 6),
            const Icon(Icons.bolt, color: AppColors.warning, size: 22),
          ]),
          const SizedBox(height: 12),
          JindungoCard(
            quote: jindungo.quote,
            source: jindungo.source,
            onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent),
            onAction: () => Navigator.pushNamed(context, AppRoutes.subscription),
          ),
          const SizedBox(height: 24),

          // Exploração Regional — mapa
          SectionTitle('Exploracao Regional'),
          const SizedBox(height: 12),
          Material(
            color: const Color(0xFF1A1414),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pushNamed(context, AppRoutes.map),
              child: Container(
                height: 130,
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Positioned(
                      right: 8, top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.map, color: Colors.white),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mapa Interativo', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('Descubra a historia por provincia',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          EhCard(
            color: AppColors.surfaceLow,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Sabia que?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
              ]),
              const SizedBox(height: 10),
              Text(data.didYouKnow()),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.tag, required this.title, required this.icon, required this.onTap});
  final String tag;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 78,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 34),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tag, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14, height: 1.2)),
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
    );
  }
}
