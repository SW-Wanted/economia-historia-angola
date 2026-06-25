import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/responsive.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_illustration.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _filter = 0;
  static const _filters = ['Todos', 'Microtextos', 'Jindungo 🌶️', 'Províncias', 'Vídeos'];

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      index: 1,
      child: Scaffold(
        appBar: _header(context),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 12, AppSpacing.margin, 96),
                children: [
                  _searchBar(context),
                  const SizedBox(height: 16),
                  _chips(context),
                  const SizedBox(height: 20),
                  _heritageInsight(context),
                  const SizedBox(height: 20),
                  _imageCard(
                    context,
                    badge: 'MICROTEXTO',
                    badgeColor: AppColors.primary,
                    icon: Icons.lock,
                    scene: EhScene.currency,
                    title: 'As Reformas Monetárias do Kwanza (1990–1999)',
                    minutes: 6,
                    views: '1.2k',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent),
                  ),
                  const SizedBox(height: 20),
                  _imageCard(
                    context,
                    badge: 'VÍDEO',
                    badgeColor: AppColors.navy,
                    isVideo: true,
                    scene: EhScene.market,
                    title: 'A Rota do Sal: Comércio Pré-Colonial na Costa Sul',
                    description: 'Uma jornada visual pelas antigas rotas comerciais que moldaram o intercâmbio regional.',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.videoPlayer),
                  ),
                  const SizedBox(height: 20),
                  _imageCard(
                    context,
                    badge: 'PODCAST',
                    badgeColor: const Color(0xFF45132B),
                    isPodcast: true,
                    scene: EhScene.podcast,
                    title: 'Conversas de Economia: O Petróleo e o Futuro',
                    description: 'Episódio 4 • 28 min — uma conversa sobre dependência e diversificação.',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.podcastPlayer),
                  ),
                  const SizedBox(height: 20),
                  _compactCard(
                    context,
                    category: 'ECONOMIA POLÍTICA',
                    title: 'Instituições e Crescimento no Pós-Independência',
                    author: 'Dra. Helena Van-Dúnem',
                    scene: EhScene.institution,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.reading),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  PreferredSizeWidget _header(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Explorar', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w800)),
      centerTitle: false,
      titleSpacing: 20,
    );
  }

  // ---------- Pesquisa ----------
  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.searchResults),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.secondary),
            const SizedBox(width: 12),
            Text('Pesquisar história e economia...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondary)),
          ],
        ),
      ),
    );
  }

  // ---------- Chips ----------
  Widget _chips(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = i == _filter;
          return GestureDetector(
            onTap: () => setState(() => _filter = i),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: active ? AppColors.navy : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: active ? AppColors.navy : AppColors.outlineVariant.withValues(alpha: .6)),
              ),
              child: Text(
                _filters[i],
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      color: active ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- Heritage Insight ----------
  Widget _heritageInsight(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, AppRoutes.reading),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Stack(
            children: [
              Positioned(
                right: -10, top: 4,
                child: Icon(Icons.history_edu, size: 92, color: Colors.white.withValues(alpha: .10)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text('HERITAGE INSIGHT',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white, letterSpacing: 1.4, fontWeight: FontWeight.w800, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'O Ciclo da Borracha no Planalto Central: Uma análise da resistência comercial.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontStyle: FontStyle.italic, fontSize: 20, height: 1.3, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Explora as dinâmicas de poder entre os reinos locais e a administração colonial no século XIX.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .85), height: 1.45),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Cartão com imagem ----------
  Widget _imageCard(
    BuildContext context, {
    required String badge,
    required Color badgeColor,
    required EhScene scene,
    required String title,
    IconData? icon,
    bool isVideo = false,
    bool isPodcast = false,
    int? minutes,
    String? views,
    String? description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ilustração vetorial local (offline)
            Stack(
              children: [
                EhIllustration(scene: scene, height: 180),
                Positioned(
                  left: 16, top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(badge, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
                if (icon != null)
                  Positioned(
                    right: 16, top: 16,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(icon, color: AppColors.primary, size: 18),
                    ),
                  ),
                if (isVideo || isPodcast)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .85), shape: BoxShape.circle),
                        child: Icon(isPodcast ? Icons.headphones : Icons.play_arrow, color: AppColors.primary, size: 32),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19, height: 1.25)),
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.45)),
                  ],
                  if (minutes != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text('$minutes min leitura', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 13)),
                        const SizedBox(width: 18),
                        const Icon(Icons.visibility_outlined, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(views ?? '', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Cartão compacto ----------
  Widget _compactCard(
    BuildContext context, {
    required String category,
    required String title,
    required String author,
    required EhScene scene,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(category, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, letterSpacing: .8, fontWeight: FontWeight.w800, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17, height: 1.25)),
                      const SizedBox(height: 8),
                      Text(author, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 76,
                  child: EhIllustration(
                    scene: scene,
                    height: 76,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
