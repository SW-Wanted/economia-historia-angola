import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/backend_service.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_card.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/jindungo_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = const MockDataService();
    final user = BackendService.instance.cachedUser;
    final resume = data.continueReading();
    final quiz = data.weeklyQuiz();
    final jindungo = data.featuredJindungo();
    return BottomNavShell(
      index: 0,
      child: ScreenFrame(
        title: 'Economia com História',
        paddingBottom: 96,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Olá, ${user.name.split(' ').first}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
              ),
              const Text('👋', style: TextStyle(fontSize: 24)),
            ],
          ),
          Text('Bem-vindo de volta à sua viagem pela economia angolana.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          const SizedBox(height: 20),

          // ---------- Continuar onde parou ----------
          Text('Continuar onde parou', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          EhCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.reading),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: EhIllustration(scene: EhScene.currency, width: 64, height: 64, borderRadius: BorderRadius.circular(14)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(resume.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(resume.subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
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
                        child: Text('${resume.percent}% concluído',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ---------- Quiz da semana ----------
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
                        Text(quiz.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.quizHub),
                          style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                          child: const Text('COMEÇAR AGORA'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ---------- O que pode explorar (módulos) ----------
          SectionTitle('O que pode explorar'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _module(context, Icons.article_outlined, 'Textos', 'Microtextos e artigos', AppRoutes.explore),
              _module(context, Icons.headphones_outlined, 'Podcasts', 'Ouça e aprenda', AppRoutes.podcastPlayer),
              _module(context, Icons.quiz_outlined, 'Quizzes', 'Teste-se e pontue', AppRoutes.quizHub),
              _module(context, Icons.forum_outlined, 'Fórum', 'Debata com a comunidade', AppRoutes.forum),
            ],
          ),
          const SizedBox(height: 24),

          // ---------- Destaques ----------
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
                final scene = i.isEven ? EhScene.market : EhScene.rubber;
                return _Highlight(tag: h.tag, title: h.title, scene: scene,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.reading));
              },
            ),
          ),
          const SizedBox(height: 24),

          // ---------- Notícias / novidades ----------
          SectionTitle('Novidades da plataforma'),
          const SizedBox(height: 12),
          _news(context, Icons.podcasts, 'Novo podcast disponível', 'Conversas de Economia • Episódio 4 já no ar.', AppRoutes.podcastPlayer),
          const SizedBox(height: 10),
          _news(context, Icons.emoji_events_outlined, 'Ranking atualizado', 'Veja a sua nova posição na Liga Jindungo.', AppRoutes.ranking),
          const SizedBox(height: 10),
          _news(context, Icons.forum_outlined, 'Debate em destaque', '"O impacto das ferrovias no séc. XX" está animado.', AppRoutes.forum),
          const SizedBox(height: 24),

          // ---------- Estatísticas da comunidade ----------
          SectionTitle('A comunidade em números'),
          const SizedBox(height: 12),
          Row(children: const [
            Expanded(child: _CommStat(icon: Icons.groups_outlined, value: '1.284', label: 'Membros')),
            SizedBox(width: 12),
            Expanded(child: _CommStat(icon: Icons.quiz_outlined, value: '312', label: 'Quizzes hoje')),
            SizedBox(width: 12),
            Expanded(child: _CommStat(icon: Icons.menu_book_outlined, value: '46', label: 'Conteúdos')),
          ]),
          const SizedBox(height: 24),

          // ---------- Atividade recente ----------
          SectionTitle('Atividade recente'),
          const SizedBox(height: 12),
          _activity(context, 'AM', 'Ana Muachia comentou no fórum', 'há 12 min'),
          _activity(context, 'JD', 'João Domingos subiu 2 lugares no ranking', 'há 35 min'),
          _activity(context, 'BN', 'Beatriz Neto concluiu o Quiz do Café', 'há 1 hora'),
          const SizedBox(height: 24),

          // ---------- Textos com Jindungo ----------
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

          // ---------- Mapa Interativo (redesenhado) ----------
          SectionTitle('Exploração Regional'),
          const SizedBox(height: 12),
          _mapBanner(context),
          const SizedBox(height: 24),

          // ---------- Sabia que? ----------
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
          const SizedBox(height: 24),

          // ---------- Convite à comunidade ----------
          EhCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.community),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.groups_outlined, color: AppColors.navy),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Junte-se à comunidade', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                  Text('Partilhe ideias e aprenda em conjunto.',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                ]),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _module(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 26),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _news(BuildContext context, IconData icon, String title, String body, String route) {
    return EhCard(
      onTap: () => Navigator.pushNamed(context, route),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
            const SizedBox(height: 2),
            Text(body, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ]),
        ),
        const Icon(Icons.chevron_right, color: AppColors.outline),
      ]),
    );
  }

  Widget _activity(BuildContext context, String initials, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surfaceContainer,
          child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        const SizedBox(width: 8),
        Text(time, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]),
    );
  }

  Widget _mapBanner(BuildContext context) {
    return Material(
      color: AppColors.navy,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, AppRoutes.map),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: EhIllustration(
                  scene: EhScene.map,
                  width: 104,
                  height: 110,
                  borderRadius: BorderRadius.circular(16),
                  tone: const Color(0xFF002336),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), borderRadius: BorderRadius.circular(6)),
                      child: const Text('18 PROVÍNCIAS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 8),
                    Text('Mapa Interativo', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('Toque numa província e descubra indicadores económicos, história e conteúdos locais.',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70, height: 1.4)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Text('Explorar agora', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.tag, required this.title, required this.scene, required this.onTap});
  final String tag;
  final String title;
  final EhScene scene;
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
                EhIllustration(scene: scene, height: 84),
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

class _CommStat extends StatelessWidget {
  const _CommStat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]),
    );
  }
}
