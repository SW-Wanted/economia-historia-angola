import '../models/feed.dart';
import 'backend_service.dart';

/// Motor de recomendação da Home.
///
/// Não usa Machine Learning: aplica **regras inteligentes** sobre os dados
/// reais do backend (categorias seguidas, popularidade, recência) para produzir
/// um feed diversificado. O catálogo é carregado por [load] a partir do
/// `BackendService`; enquanto não houver conteúdos no backend, fica vazio e as
/// telas mostram o estado "sem conteúdos disponíveis".
class FeedService {
  FeedService._();

  static final FeedService instance = FeedService._();

  /// Categorias que o utilizador escolheu seguir (no cadastro/perfil). Quando
  /// vazio, o feed recorre ao modo de descoberta (populares + recentes).
  List<String> favoriteCategories = const [];

  /// Categorias de conteúdos que o utilizador leu recentemente — usadas para
  /// sugerir quizzes e conteúdos "baseados nas suas leituras".
  List<String> readingHistory = const [];

  /// Comunidades em que o utilizador está inserido — o feed também mostra o que
  /// é publicado nelas (estilo Reddit `eh/…`).
  List<String> userCommunities = const [];

  /// Comunidades que o utilizador gere/possui e onde pode publicar conteúdos.
  /// Se estiver vazia, o seletor de comunidade fica inativo na criação.
  List<String> ownedCommunities = const [];

  bool get _hasSignal => favoriteCategories.isNotEmpty || readingHistory.isNotEmpty;

  // --------------------------------------------------------------- Catálogo

  /// Catálogo real carregado do backend. Vazio até [load] terminar.
  final List<FeedContent> _catalog = [];

  bool _loaded = false;

  /// Indica se o catálogo já foi carregado ao menos uma vez do backend.
  bool get isLoaded => _loaded;

  /// Carrega (uma vez) o catálogo do backend. Chamado pelas telas antes de
  /// mostrarem o feed. É idempotente: chamadas repetidas não recarregam, exceto
  /// se [force] for verdadeiro (usado no pull-to-refresh).
  Future<void> load({bool force = false}) async {
    if (_loaded && !force) return;
    final items = await BackendService.instance.feedCatalog();
    _catalog
      ..clear()
      ..addAll(items);
    _loaded = true;
  }

  List<FeedContent> get _articles =>
      _catalog.where((c) => c.type == FeedContentType.article || c.type == FeedContentType.jindungo).toList();

  /// Títulos dos artigos — usados, por exemplo, para associar um artigo a um
  /// fórum de debate na sua criação.
  List<String> get articleTitles => _articles.map((c) => c.title).toList();

  /// Todo o catálogo (leitura), para ecrãs como o Explorar.
  List<FeedContent> get catalog => List.unmodifiable(_catalog);

  /// Constrói uma entrada de feed (conteúdo + motivo) para um conteúdo — reutiliza
  /// as mesmas regras de rotulagem do feed principal.
  FeedEntry entryFor(FeedContent c) => FeedEntry(
        content: c,
        reason: _discoverReason(c),
        reasonCategory: _fromMyCommunity(c) ? c.communityHandle : null,
      );

  /// Pontuação de viralidade (para ordenar conteúdos/fóruns "virais").
  double viralScore(FeedContent c) => _trendScore(c);

  // -------------------------------------------------- Categorias do Explorar

  /// Score de sugestão: popularidade + recência + afinidade com os interesses.
  double _suggestScore(FeedContent c) {
    final interest = favoriteCategories.contains(c.category) || readingHistory.contains(c.category);
    return _popularity(c) + _recency(c) * 25 + (interest ? 2500 : 0);
  }

  /// Tudo (mais recente primeiro).
  List<FeedContent> exploreAll() =>
      [..._catalog]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

  /// Virais — maior pontuação de tendência primeiro.
  List<FeedContent> exploreViral() =>
      [..._catalog]..sort((a, b) => _trendScore(b).compareTo(_trendScore(a)));

  /// Novos — publicados há menos tempo primeiro.
  List<FeedContent> exploreNew() =>
      [..._catalog]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

  /// Do interesse do utilizador — categorias favoritas ou já lidas.
  List<FeedContent> exploreForYou() {
    final interests = {...favoriteCategories, ...readingHistory};
    return _catalog.where((c) => interests.contains(c.category)).toList()
      ..sort((a, b) => (_popularity(b) + _recency(b) * 30).compareTo(_popularity(a) + _recency(a) * 30));
  }

  /// Sugeridos — mistura de popularidade, recência e afinidade.
  List<FeedContent> exploreSuggested() =>
      [..._catalog]..sort((a, b) => _suggestScore(b).compareTo(_suggestScore(a)));

  // --------------------------------------------------------------- Métricas

  /// Popularidade combinada — não usa um único critério: pondera visualizações,
  /// gostos, comentários e partilhas.
  double _popularity(FeedContent c) =>
      c.views + c.likes * 4 + c.comments * 10 + c.shares * 15;

  /// Pontuação de tendência: combina popularidade com o **crescimento recente**
  /// das visualizações, destacando o que está a "aquecer" agora.
  double _trendScore(FeedContent c) =>
      _popularity(c) * 0.6 + c.viewGrowth * 90 + c.comments * 20 + c.shares * 25;

  /// Recência (maior = mais novo). Satura ao fim de ~60 dias.
  double _recency(FeedContent c) => (60 - c.ageInDays).clamp(0, 60).toDouble();

  /// Pequena variação determinística por semente — faz o feed reorganizar-se a
  /// cada atualização (pull-to-refresh) sem perder relevância.
  double _jitter(FeedContent c, int seed) => (c.id.hashCode ^ seed).abs() % 100 / 10;

  // ----------------------------------------------------- Secções do feed

  /// "Continue a ler": artigos começados mas não terminados, do mais recente.
  List<FeedEntry> continueReading() {
    final started = _articles.where((c) => c.isStarted).toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return [for (final c in started) FeedEntry(content: c, reason: FeedReason.continueStudy)];
  }

  /// "Recomendado para si": prioriza categorias favoritas e mistura conteúdos
  /// recentes com populares. Sem sinal do utilizador, cai para populares+recentes.
  List<FeedEntry> recommendedForYou({int seed = 0, int limit = 6}) {
    final pool = _hasSignal
        ? _articles.where((c) => favoriteCategories.contains(c.category)).toList()
        : _articles.toList();
    final base = pool.isEmpty ? _articles.toList() : pool;

    // Mistura recentes + populares: ordena por duas ordenações e intercala.
    final byRecency = [...base]..sort((a, b) =>
        (_recency(b) + _jitter(b, seed)).compareTo(_recency(a) + _jitter(a, seed)));
    final byPopularity = [...base]..sort((a, b) =>
        (_popularity(b) + _jitter(b, seed) * 20).compareTo(_popularity(a) + _jitter(a, seed) * 20));
    final mixed = _interleave(byRecency, byPopularity);

    return [
      for (final c in mixed.take(limit))
        FeedEntry(
          content: c,
          reason: c.isNew
              ? FeedReason.newContent
              : favoriteCategories.contains(c.category)
                  ? FeedReason.recommendedCategory
                  : FeedReason.popularWeek,
          reasonCategory: favoriteCategories.contains(c.category) ? c.category : null,
        ),
    ];
  }

  /// "Tendências da semana": ordena pela pontuação combinada de tendência.
  List<FeedEntry> trendingThisWeek({int seed = 0, int limit = 6}) {
    final items = [..._articles]
      ..sort((a, b) => (_trendScore(b) + _jitter(b, seed) * 50).compareTo(_trendScore(a) + _jitter(a, seed) * 50));
    return [
      for (final c in items.take(limit))
        FeedEntry(content: c, reason: c.viewGrowth >= 60 ? FeedReason.trending : FeedReason.popularWeek),
    ];
  }

  /// Categoria favorita em destaque na secção "Porque segue …" — alterna a cada
  /// atualização para dar variedade quando o utilizador segue várias.
  String? spotlightCategory(int seed) {
    if (favoriteCategories.isEmpty) return null;
    return favoriteCategories[seed.abs() % favoriteCategories.length];
  }

  /// "Porque segue {categoria}": conteúdos relacionados com uma favorita.
  List<FeedEntry> becauseYouFollow(String category, {int limit = 6}) {
    final items = _articles.where((c) => c.category == category).toList()
      ..sort((a, b) => _popularity(b).compareTo(_popularity(a)));
    return [
      for (final c in items.take(limit))
        FeedEntry(content: c, reason: FeedReason.recommendedCategory, reasonCategory: category),
    ];
  }

  /// Podcasts recomendados: favoritos primeiro, depois populares e recentes.
  List<FeedEntry> recommendedPodcasts({int seed = 0, int limit = 6}) {
    final podcasts = _catalog.where((c) => c.type == FeedContentType.podcast).toList()
      ..sort((a, b) {
        final favA = favoriteCategories.contains(a.category) ? 1 : 0;
        final favB = favoriteCategories.contains(b.category) ? 1 : 0;
        if (favA != favB) return favB - favA;
        return (_popularity(b) + _recency(b) * 30 + _jitter(b, seed) * 20)
            .compareTo(_popularity(a) + _recency(a) * 30 + _jitter(a, seed) * 20);
      });
    return [
      for (final c in podcasts.take(limit))
        FeedEntry(
          content: c,
          reason: favoriteCategories.contains(c.category)
              ? FeedReason.recommendedCategory
              : c.isNew
                  ? FeedReason.newContent
                  : FeedReason.popularWeek,
          reasonCategory: favoriteCategories.contains(c.category) ? c.category : null,
        ),
    ];
  }

  /// Quizzes sugeridos: relacionados com leituras recentes e categorias favoritas.
  List<FeedEntry> suggestedQuizzes({int limit = 6}) {
    final interests = {...readingHistory, ...favoriteCategories};
    final quizzes = _catalog.where((c) => c.type == FeedContentType.quiz).toList()
      ..sort((a, b) {
        final relA = interests.contains(a.category) ? 1 : 0;
        final relB = interests.contains(b.category) ? 1 : 0;
        if (relA != relB) return relB - relA;
        return _popularity(b).compareTo(_popularity(a));
      });
    return [
      for (final c in quizzes.take(limit))
        FeedEntry(
          content: c,
          reason: readingHistory.contains(c.category)
              ? FeedReason.basedOnReading
              : favoriteCategories.contains(c.category)
                  ? FeedReason.recommendedCategory
                  : FeedReason.popularWeek,
          reasonCategory: favoriteCategories.contains(c.category) ? c.category : null,
        ),
    ];
  }

  /// Texto Jindungo em destaque (identidade da marca).
  FeedContent? featuredJindungo() {
    final list = _catalog.where((c) => c.type == FeedContentType.jindungo).toList()
      ..sort((a, b) => _trendScore(b).compareTo(_trendScore(a)));
    return list.isEmpty ? null : list.first;
  }

  /// "Descubra novas áreas": categorias pouco/não exploradas pelo utilizador.
  List<String> discoverCategories() {
    final known = {...favoriteCategories, ...readingHistory};
    final all = _catalog.map((c) => c.category).toSet();
    final unexplored = all.difference(known).toList()..sort();
    return unexplored;
  }

  // ------------------------------------------------- Feed infinito (misto)

  static const int _pageSize = 5;

  /// Número máximo de páginas do feed de descoberta sem repetir conteúdos.
  int get maxDiscoverPages => _catalog.isEmpty ? 0 : (_catalog.length / _pageSize).ceil();

  bool hasMoreDiscover(int page) => page < maxDiscoverPages;

  /// Página do feed misto de descoberta, com **diversidade**: evita mostrar
  /// vários conteúdos seguidos da mesma categoria e mistura tipos (artigos,
  /// podcasts, quizzes). Não recicla o catálogo: cada conteúdo aparece uma só
  /// vez até ao próximo refresh.
  List<FeedEntry> discoverPage(int page, {int seed = 0}) {
    if (_catalog.isEmpty) return const [];
    final pageSeed = seed + page * 97;
    double score(FeedContent c) {
      final interest = favoriteCategories.contains(c.category) || readingHistory.contains(c.category);
      final fromMyCommunity = c.community != null && userCommunities.contains(c.community);
      return _popularity(c) +
          _recency(c) * 25 +
          (interest ? 3000 : 0) +
          (fromMyCommunity ? 3500 : 0) +
          _jitter(c, pageSeed) * 60;
    }

    final ranked = [..._catalog]..sort((a, b) => score(b).compareTo(score(a)));
    final diversified = _diversify(ranked);
    final start = page * _pageSize;
    if (start >= diversified.length) return const [];
    final end = start + _pageSize > diversified.length ? diversified.length : start + _pageSize;
    final window = diversified.sublist(start, end);
    return [
      for (final c in window)
        FeedEntry(
          content: c,
          reason: _discoverReason(c),
          reasonCategory: _fromMyCommunity(c) ? c.communityHandle : null,
        ),
    ];
  }

  bool _fromMyCommunity(FeedContent c) => c.community != null && userCommunities.contains(c.community);

  FeedReason _discoverReason(FeedContent c) {
    if (_fromMyCommunity(c)) return FeedReason.community;
    // Conteúdo/debate viral aparece como tendência, mesmo fora das favoritas.
    if (c.viewGrowth >= 80) return FeedReason.trending;
    if (!favoriteCategories.contains(c.category) && !readingHistory.contains(c.category)) {
      return FeedReason.discover;
    }
    if (c.isNew) return FeedReason.newContent;
    if (c.viewGrowth >= 60) return FeedReason.trending;
    return FeedReason.recommendedCategory;
  }

  // ------------------------------------------------------------ utilitários

  /// Intercala duas listas ordenadas removendo duplicados, preservando ordem.
  List<FeedContent> _interleave(List<FeedContent> a, List<FeedContent> b) {
    final result = <FeedContent>[];
    final seen = <String>{};
    final max = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < max; i++) {
      for (final list in [a, b]) {
        if (i < list.length && seen.add(list[i].id)) result.add(list[i]);
      }
    }
    return result;
  }

  /// Reordena evitando duas categorias iguais consecutivas quando possível.
  List<FeedContent> _diversify(List<FeedContent> items) {
    final remaining = [...items];
    final result = <FeedContent>[];
    String? lastCategory;
    while (remaining.isNotEmpty) {
      final index = remaining.indexWhere((c) => c.category != lastCategory);
      final pick = remaining.removeAt(index == -1 ? 0 : index);
      result.add(pick);
      lastCategory = pick.category;
    }
    return result;
  }
}
