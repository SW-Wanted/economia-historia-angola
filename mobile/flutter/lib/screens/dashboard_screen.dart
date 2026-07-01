import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/responsive.dart';
import '../models/feed.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/feed_content_card.dart';
import '../widgets/jindungo_card.dart';
import '../widgets/section_title.dart';

/// Home reimaginada como um **feed inteligente de descoberta**.
///
/// Deixa de ser uma página institucional estática: cada visita apresenta
/// conteúdos personalizados (categorias favoritas, histórico, popularidade e
/// tendências), com selos que explicam o porquê de cada recomendação, scroll
/// infinito e reorganização ao atualizar (pull-to-refresh). A arquitetura e o
/// Design System mantêm-se — a lógica de recomendação vive no [FeedService].
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FeedService _feed = FeedService.instance;
  final ScrollController _controller = ScrollController();

  final List<FeedEntry> _discover = [];
  int _page = 0;
  int _seed = 0;
  bool _loadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _seed = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _loadMore();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    if (pos.pixels >= pos.maxScrollExtent - 400) _loadMore();
  }

  void _loadMore() {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    // Pequeno atraso simula o carregamento assíncrono de novas páginas.
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      final next = _feed.discoverPage(_page, seed: _seed);
      setState(() {
        _discover.addAll(next);
        _page++;
        _hasMore = _feed.hasMoreDiscover(_page);
        _loadingMore = false;
      });
    });
  }

  /// Pull-to-refresh: nova semente → todas as secções (curadas + descoberta)
  /// são reorganizadas, dando a sensação de descoberta contínua.
  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _seed = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      _discover.clear();
      _page = 0;
      _hasMore = true;
      _loadingMore = false;
    });
    _loadMore();
  }

  void _open(FeedEntry entry) => Navigator.pushNamed(context, entry.content.type.route);

  @override
  Widget build(BuildContext context) {
    // 1 (cabeçalho curado) + descoberta + 1 (rodapé: loader ou comunidade).
    final itemCount = 1 + _discover.length + 1;

    return BottomNavShell(
      index: 0,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppHeader(title: 'Economia com História'),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _controller,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 16, AppSpacing.margin, 110),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == 0) return _curatedHeader(context);
                    if (index <= _discover.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FeedContentTile(entry: _discover[index - 1], onTap: () => _open(_discover[index - 1])),
                      );
                    }
                    return _footer(context);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------- Cabeçalho curado

  Widget _curatedHeader(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    final continueReading = _feed.continueReading();
    final recommended = _feed.recommendedForYou(seed: _seed);
    final trending = _feed.trendingThisWeek(seed: _seed);
    final spotlight = _feed.spotlightCategory(_seed);
    final followed = spotlight == null ? const <FeedEntry>[] : _feed.becauseYouFollow(spotlight);
    final podcasts = _feed.recommendedPodcasts(seed: _seed);
    final quizzes = _feed.suggestedQuizzes();
    final jindungo = _feed.featuredJindungo();
    final discoverCats = _feed.discoverCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saudação personalizada.
        Row(
          children: [
            Expanded(
              child: Text('Olá, ${user.name.split(' ').first}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
            ),
            const Text('👋', style: TextStyle(fontSize: 24)),
          ],
        ),
        Text('Feito para si — conteúdos que combinam com o que gosta de aprender.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 22),

        // Continue a ler.
        if (continueReading.isNotEmpty) ...[
          const SectionTitle('Continue a ler'),
          const SizedBox(height: 12),
          _carousel(height: 152, itemCount: continueReading.length, builder: (i) {
            final e = continueReading[i];
            return ContinueReadingCard(entry: e, onTap: () => _open(e));
          }),
          const SizedBox(height: 26),
        ],

        // Recomendado para si.
        if (recommended.isNotEmpty) ...[
          _header('Recomendado para si', AppRoutes.explore),
          const SizedBox(height: 12),
          _cardCarousel(recommended),
          const SizedBox(height: 26),
        ],

        // Tendências da semana.
        if (trending.isNotEmpty) ...[
          _header('Tendências da semana', AppRoutes.explore),
          const SizedBox(height: 12),
          _cardCarousel(trending),
          const SizedBox(height: 26),
        ],

        // Porque segue {categoria}.
        if (spotlight != null && followed.isNotEmpty) ...[
          _header('Porque segue $spotlight', AppRoutes.explore),
          const SizedBox(height: 12),
          _cardCarousel(followed),
          const SizedBox(height: 26),
        ],

        // Podcasts recomendados.
        if (podcasts.isNotEmpty) ...[
          _header('Podcasts recomendados', AppRoutes.podcastPlayer),
          const SizedBox(height: 12),
          _cardCarousel(podcasts),
          const SizedBox(height: 26),
        ],

        // Quizzes sugeridos.
        if (quizzes.isNotEmpty) ...[
          _header('Quizzes sugeridos', AppRoutes.quizHub),
          const SizedBox(height: 12),
          _cardCarousel(quizzes),
          const SizedBox(height: 26),
        ],

        // Texto Jindungo em destaque (identidade da marca).
        if (jindungo != null) ...[
          Row(children: [
            Text('Textos com Jindungo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 6),
            const Icon(Icons.local_fire_department, color: AppColors.warning, size: 22),
          ]),
          const SizedBox(height: 12),
          JindungoCard(
            quote: jindungo.subtitle,
            source: jindungo.author,
            onTap: () => Navigator.pushNamed(context, AppRoutes.restrictedContent),
            onAction: () => Navigator.pushNamed(context, AppRoutes.subscription),
          ),
          const SizedBox(height: 26),
        ],

        // Explorar mais categorias (descobrir novas áreas).
        if (discoverCats.isNotEmpty) ...[
          const SectionTitle('Descubra novas áreas'),
          const SizedBox(height: 6),
          Text('Temas ainda pouco explorados por si — ótimos para novas aprendizagens.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final c in discoverCats) _discoverChip(c)],
          ),
          const SizedBox(height: 28),
        ],

        // Início do feed de descoberta (scroll infinito).
        const SectionTitle('Continue a descobrir'),
        const SizedBox(height: 12),
      ],
    );
  }

  // ------------------------------------------------------------- utilitários

  Widget _header(String title, String route) => SectionTitle(
        title,
        action: TextButton(
          onPressed: () => Navigator.pushNamed(context, route),
          child: const Text('Ver todos', style: TextStyle(color: AppColors.primary)),
        ),
      );

  Widget _cardCarousel(List<FeedEntry> entries) => _carousel(
        height: 254,
        itemCount: entries.length,
        builder: (i) => FeedContentCard(entry: entries[i], onTap: () => _open(entries[i])),
      );

  Widget _carousel({required double height, required int itemCount, required Widget Function(int) builder}) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) => builder(i),
      ),
    );
  }

  Widget _discoverChip(String category) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: () => Navigator.pushNamed(context, AppRoutes.explore),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .6)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.explore_outlined, size: 15, color: AppColors.navy),
            const SizedBox(width: 7),
            Text(category, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- rodapé

  Widget _footer(BuildContext context) {
    if (_hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primary),
          ),
        ),
      );
    }
    // Fim do feed → a comunidade em números.
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('A comunidade em números'),
          const SizedBox(height: 12),
          Row(children: const [
            Expanded(child: _CommStat(icon: Icons.groups_outlined, value: '1.284', label: 'Membros')),
            SizedBox(width: 12),
            Expanded(child: _CommStat(icon: Icons.quiz_outlined, value: '312', label: 'Quizzes hoje')),
            SizedBox(width: 12),
            Expanded(child: _CommStat(icon: Icons.menu_book_outlined, value: '46', label: 'Conteúdos')),
          ]),
          const SizedBox(height: 20),
          Center(
            child: Text('Chegou ao fim por agora — volte mais tarde para novidades.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ),
        ],
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
