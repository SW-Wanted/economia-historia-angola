import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../models/weekly_quiz.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/angola_map.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/feed_post_tile.dart';

/// Home reimaginada como um **feed contínuo** ao estilo das redes sociais
/// (Instagram/Facebook/Reddit), adaptado à História da Economia.
///
/// As publicações ocupam praticamente toda a largura, sem cartões elevados nem
/// sombras — a separação é feita apenas por espaço em branco e divisores
/// subtis. Cada post permite curtir, comentar (bottom sheet), guardar e
/// partilhar sem sair do feed. A ordenação é personalizada pelo [FeedService]
/// (categorias favoritas, recência, popularidade, comentários, gostos) e
/// diversificada para evitar categorias consecutivas. Scroll infinito e
/// pull-to-refresh. A arquitetura e o Design System mantêm-se.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FeedService _feed = FeedService.instance;
  final ScrollController _controller = ScrollController();

  final List<FeedEntry> _posts = [];
  int _page = 0;
  int _seed = 0;
  bool _loadingMore = false;
  bool _hasMore = true;

  /// Posição (índice de post) onde surge o módulo de descoberta (mapa).
  static const int _mapAfter = 2;

  /// Garante que o catálogo do backend está carregado antes de montar o feed.
  bool _catalogReady = false;

  /// Quiz da Semana em destaque; `null` enquanto carrega ou quando nenhum admin
  /// disponibilizou um quiz semanal — nesse caso o cartão não é mostrado.
  WeeklyQuiz? _weekly;

  @override
  void initState() {
    super.initState();
    _seed = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _bootstrap();
    _controller.addListener(_onScroll);
  }

  Future<void> _bootstrap() async {
    final weekly = await BackendService.instance.weeklyQuiz();
    await _feed.load();
    if (!mounted) return;
    setState(() {
      _weekly = weekly;
      _catalogReady = true;
    });
    _loadMore();
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
    if (pos.pixels >= pos.maxScrollExtent - 600) _loadMore();
  }

  void _loadMore() {
    if (_loadingMore || !_hasMore) return;
    // Catálogo vazio (backend sem conteúdos): não há mais a paginar — evita o
    // indicador de carregamento infinito no rodapé.
    if (_catalogReady && _feed.catalog.isEmpty) {
      setState(() => _hasMore = false);
      return;
    }
    setState(() => _loadingMore = true);
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      final next = _feed.discoverPage(_page, seed: _seed);
      setState(() {
        _posts.addAll(next);
        _page++;
        _hasMore = next.isNotEmpty && _feed.hasMoreDiscover(_page);
        _loadingMore = false;
      });
    });
  }

  Future<void> _refresh() async {
    await _feed.load(force: true);
    if (!mounted) return;
    setState(() {
      _seed = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      _posts.clear();
      _page = 0;
      _hasMore = true;
      _loadingMore = false;
    });
    _loadMore();
  }

  void _open(FeedEntry entry) {
    // Conteúdo reservado (Jindungo ou comunidade privada) segue para o ecrã de
    // acesso/desbloqueio, deixando explícita a restrição.
    final route = entry.content.isRestricted ? AppRoutes.restrictedContent : entry.content.type.route;
    Navigator.pushNamed(context, route, arguments: entry.content);
  }

  /// Menu de atalhos (canto superior esquerdo): pequenos cards verticais.
  void _openMenu(BuildContext rootContext) {
    final top = MediaQuery.paddingOf(rootContext).top + kToolbarHeight - 6;
    showGeneralDialog<void>(
      context: rootContext,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black.withValues(alpha: .18),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, _, _) {
        return Stack(
          children: [
            Positioned(
              left: 12,
              top: top,
              child: FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(begin: const Offset(-.12, 0), end: Offset.zero)
                      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 214,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _menuCard(Icons.emoji_events_outlined, 'Ranking',
                              () => Navigator.pushNamed(rootContext, AppRoutes.ranking)),
                          _menuCard(Icons.quiz_outlined, 'Quizzes',
                              () => Navigator.pushNamed(rootContext, AppRoutes.quizHub)),
                          _menuCard(Icons.settings_outlined, 'Definições',
                              () => Navigator.pushNamed(rootContext, AppRoutes.settings)),
                          _menuCard(Icons.logout, 'Terminar sessão', () => _logout(rootContext), danger: true),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _menuCard(IconData icon, String label, VoidCallback action, {bool danger = false}) {
    final color = danger ? AppColors.error : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: .18),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context); // fecha o menu
            action();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
            ),
            child: Row(children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: TextStyle(color: danger ? AppColors.error : AppColors.text, fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await BackendService.instance.logout();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
  }

  /// Largura máxima confortável — mais larga na Web/tablet, preservando o
  /// conceito de feed contínuo.
  double _maxWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1100) return 720;
    if (w >= 700) return 640;
    return w;
  }

  @override
  Widget build(BuildContext context) {
    // 1 (saudação) + posts + 1 (rodapé/loader).
    final itemCount = 1 + _posts.length + 1;

    return BottomNavShell(
      index: 0,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leadingWidth: 56,
          leading: IconButton(
            tooltip: 'Menu',
            onPressed: () => _openMenu(context),
            icon: const Icon(Icons.grid_view_rounded, color: AppColors.primary),
          ),
          centerTitle: true,
          title: Text('Economia com História',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800)),
          actions: [
            IconButton(
              tooltip: 'Notificações',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
              icon: const Icon(Icons.notifications_none, color: AppColors.text),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth(context)),
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 110),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == 0) return _header(context);
                    if (index <= _posts.length) return _postAt(index - 1);
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

  /// Cabeçalho do feed: saudação + "Continue a aprender" + desafio da semana.
  Widget _header(BuildContext context) {
    final reading = _feed.continueReading();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _greeting(context),
        if (reading.isNotEmpty) _continueReading(context, reading),
        // O "Desafio da Semana" só aparece quando existe um quiz semanal real.
        if (_weekly != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: _weeklyChallenge(context, _weekly!),
          ),
        _separator(),
      ],
    );
  }

  /// Saudação personalizada, com avatar e cumprimento consoante a hora.
  Widget _greeting(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    final first = user.name.split(' ').first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_salutation(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w800, letterSpacing: .3)),
                const SizedBox(height: 2),
                Row(children: [
                  Flexible(
                    child: Text(first,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26)),
                  ),
                  const SizedBox(width: 6),
                  const Text('👋', style: TextStyle(fontSize: 22)),
                ]),
                const SizedBox(height: 4),
                Text('O seu feed de História da Economia, feito a pensar em si.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, AppRoutes.profile);
              if (mounted) setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: .35), width: 1.6),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.surfaceContainer,
                backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl != null
                    ? null
                    : Text(user.initials,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _salutation() {
    final h = DateTime.now().hour;
    if (h < 12) return 'BOM DIA';
    if (h < 19) return 'BOA TARDE';
    return 'BOA NOITE';
  }

  /// Cartão "Desafio da semana" (quiz em destaque, real).
  Widget _weeklyChallenge(BuildContext context, WeeklyQuiz quiz) {
    const gold = AppColors.warning;
    void openQuiz() => Navigator.pushNamed(context, AppRoutes.quizQuestion, arguments: quiz);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .28), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
              ),
            ),
            Positioned(right: -12, top: -12, child: Icon(Icons.emoji_objects_outlined, size: 120, color: Colors.white.withValues(alpha: .10))),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: openQuiz,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: gold.withValues(alpha: .18),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: gold.withValues(alpha: .45)),
                        ),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.emoji_objects_outlined, color: gold, size: 15),
                          SizedBox(width: 6),
                          Text('DESAFIO DA SEMANA',
                              style: TextStyle(color: Colors.white, letterSpacing: .6, fontWeight: FontWeight.w800, fontSize: 11)),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      Text(quiz.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                      if (quiz.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(quiz.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.35)),
                      ],
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: openQuiz,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Começar agora'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Secção "Continue a ler": carrossel horizontal de artigos em progresso.
  Widget _continueReading(BuildContext context, List<FeedEntry> reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(children: [
            const Icon(Icons.school_outlined, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Continue a aprender', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
          ]),
        ),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: reading.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _continueCard(context, reading[i]),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _continueCard(BuildContext context, FeedEntry entry) {
    final c = entry.content;
    return SizedBox(
      width: 268,
      child: Material(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _open(entry),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              EhIllustration(scene: c.scene, width: 56, height: 56, borderRadius: BorderRadius.circular(12)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(c.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 13.5, height: 1.2)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: c.readProgress,
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceHighest,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(children: [
                      Text('${c.percent}% concluído',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11.5)),
                      const Spacer(),
                      Text('Continuar',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11.5)),
                      const Icon(Icons.arrow_forward, size: 13, color: AppColors.primary),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  /// Um post com o separador subtil por baixo; após o [_mapAfter]-ésimo post,
  /// intercala o módulo de descoberta regional (mapa interativo).
  Widget _postAt(int i) {
    final entry = _posts[i];
    final withMap = i == _mapAfter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedPostTile(entry: entry, onOpen: () => _open(entry)),
        _separator(),
        if (withMap) ...[
          _mapModule(context),
          _separator(),
        ],
      ],
    );
  }

  /// Separação leve entre publicações: apenas espaço em branco (sem cartões).
  Widget _separator() => Container(height: 8, color: AppColors.background);

  // --------------------------------------------------- Módulo de descoberta

  /// Exploração regional inserida no feed (mantém a identidade da plataforma,
  /// sem sombras — apenas um bloco de cor cheia, coerente com o feed).
  Widget _mapModule(BuildContext context) {
    return Material(
      color: AppColors.navy,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.map),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            Container(
              width: 92,
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: .12)),
              ),
              child: const Center(child: AngolaMap(fill: Colors.white, markerIds: ['AOLUA', 'AOBGU', 'AOHUA'])),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), borderRadius: BorderRadius.circular(6)),
                    child: const Text('EXPLORAR · 18 PROVÍNCIAS',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 8),
                  Text('Mapa Interativo', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('Toque numa província e descubra indicadores económicos, história e conteúdos locais.',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70, height: 1.4)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text('Explorar agora',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ]),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- Rodapé

  Widget _footer(BuildContext context) {
    // A carregar o catálogo do backend, ou a paginar mais conteúdos.
    if (!_catalogReady || _hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: AppLoadingIndicator(size: 72, showDots: false)),
      );
    }
    // Catálogo carregado mas sem qualquer publicação: backend ainda sem conteúdos.
    if (_posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
        child: Center(
          child: Column(children: [
            const Icon(Icons.article_outlined, size: 44, color: AppColors.outline),
            const SizedBox(height: 12),
            Text('Ainda não há conteúdos disponíveis',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Assim que forem publicados conteúdos, aparecerão aqui no seu feed.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ]),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Center(
        child: Text('Chegou ao fim por agora — puxe para atualizar e ver novidades.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ),
    );
  }
}
