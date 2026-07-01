import '../models/feed.dart';
import '../widgets/eh_illustration.dart';

/// Motor de recomendação da Home.
///
/// Não usa Machine Learning: aplica **regras inteligentes** sobre os dados já
/// existentes (categorias favoritas, histórico de leitura, popularidade,
/// tendência e recência) para produzir um feed personalizado, diversificado e
/// diferente a cada visita. Está isolado num serviço, seguindo o padrão
/// offline-first do projeto — no futuro pode ser alimentado por um endpoint
/// `GET /feed/home` sem alterar a UI.
class FeedService {
  FeedService._();

  static final FeedService instance = FeedService._();

  /// Categorias que o utilizador escolheu seguir (no cadastro/perfil). Quando
  /// vazio, o feed recorre ao modo de descoberta (populares + recentes).
  List<String> favoriteCategories = const ['Economia Colonial', 'História de Angola', 'Agricultura'];

  /// Categorias de conteúdos que o utilizador leu recentemente — usadas para
  /// sugerir quizzes e conteúdos "baseados nas suas leituras".
  List<String> readingHistory = const ['Agricultura', 'Moeda & Finanças'];

  bool get _hasSignal => favoriteCategories.isNotEmpty || readingHistory.isNotEmpty;

  // --------------------------------------------------------------- Catálogo

  static final DateTime _now = DateTime.now();

  static DateTime _daysAgo(int d) => _now.subtract(Duration(days: d));

  /// Catálogo enriquecido com métricas de interação. Numa app real viria do
  /// backend; aqui simula os sinais necessários às regras de recomendação.
  late final List<FeedContent> _catalog = [
    FeedContent(
      id: 'a1', type: FeedContentType.article, scene: EhScene.currency,
      title: 'O que é o Kwanza? A moeda como soberania',
      subtitle: 'Da independência às redenominações: a moeda nacional e as escolhas económicas do país.',
      category: 'Moeda & Finanças', author: 'Prof. Carlos Lopes', minutes: 5,
      publishedAt: _daysAgo(2), views: 3240, likes: 412, comments: 58, shares: 96, viewGrowth: 74,
      readProgress: .35,
    ),
    FeedContent(
      id: 'a2', type: FeedContentType.article, scene: EhScene.market,
      title: 'Caminho de Ferro de Benguela: o corredor que redesenhou o comércio',
      subtitle: 'Infraestrutura, exportação e a geografia económica do centro de Angola no século XX.',
      category: 'Infraestrutura', author: 'Ana Muachia', minutes: 8,
      publishedAt: _daysAgo(5), views: 5120, likes: 690, comments: 84, shares: 172, viewGrowth: 41,
    ),
    FeedContent(
      id: 'a3', type: FeedContentType.article, scene: EhScene.rubber,
      title: 'O ciclo do café que transformou o norte de Angola',
      subtitle: 'Como uma cultura de exportação moldou infraestrutura, emprego e dependência externa.',
      category: 'Agricultura', author: 'Dr. Kambinda', minutes: 6,
      publishedAt: _daysAgo(1), views: 2180, likes: 301, comments: 44, shares: 63, viewGrowth: 88,
      readProgress: .6,
    ),
    FeedContent(
      id: 'a4', type: FeedContentType.jindungo, scene: EhScene.institution,
      title: 'Textos Jindungo: Petróleo e poder',
      subtitle: 'A renda do petróleo é uma bênção que cobra juros — financia o presente e hipoteca o futuro.',
      category: 'Petróleo', author: 'Dr. Kambinda', minutes: 12,
      publishedAt: _daysAgo(3), views: 4870, likes: 980, comments: 214, shares: 340, viewGrowth: 120,
      locked: true,
    ),
    FeedContent(
      id: 'a5', type: FeedContentType.article, scene: EhScene.institution,
      title: 'Economia colonial: as raízes das assimetrias regionais',
      subtitle: 'Concessões, trabalho forçado e as estruturas que ainda hoje marcam o território.',
      category: 'Economia Colonial', author: 'Prof. Carlos Lopes', minutes: 9,
      publishedAt: _daysAgo(4), views: 3960, likes: 540, comments: 72, shares: 128, viewGrowth: 52,
    ),
    FeedContent(
      id: 'a6', type: FeedContentType.article, scene: EhScene.map,
      title: 'Rotas de comércio no século XIX: do interior ao litoral',
      subtitle: 'Como as rotas comerciais moldaram estruturas de poder e mercados regionais.',
      category: 'Comércio', author: 'Beatriz Neto', minutes: 7,
      publishedAt: _daysAgo(12), views: 2760, likes: 288, comments: 36, shares: 54, viewGrowth: 18,
    ),
    FeedContent(
      id: 'a7', type: FeedContentType.article, scene: EhScene.market,
      title: 'O comércio no Reino do Kongo',
      subtitle: 'Trocas, moeda-mercadoria e a organização económica antes da colonização.',
      category: 'História de Angola', author: 'Beatriz Neto', minutes: 6,
      publishedAt: _daysAgo(8), views: 3410, likes: 470, comments: 61, shares: 110, viewGrowth: 35,
    ),
    FeedContent(
      id: 'a8', type: FeedContentType.article, scene: EhScene.currency,
      title: 'Reformas monetárias do Kwanza: 1990–1999',
      subtitle: 'Como as redenominações refletiram ciclos de inflação e estabilização.',
      category: 'Moeda & Finanças', author: 'Dr. Kambinda', minutes: 7,
      publishedAt: _daysAgo(20), views: 1980, likes: 210, comments: 29, shares: 41, viewGrowth: 9,
    ),
    FeedContent(
      id: 'a9', type: FeedContentType.article, scene: EhScene.rubber,
      title: 'Agricultura e desenvolvimento regional no interior',
      subtitle: 'O papel do café, da mandioca e da pecuária nas províncias do interior.',
      category: 'Agricultura', author: 'Beatriz Neto', minutes: 6,
      publishedAt: _daysAgo(6), views: 2510, likes: 260, comments: 33, shares: 58, viewGrowth: 47,
    ),
    FeedContent(
      id: 'a10', type: FeedContentType.article, scene: EhScene.institution,
      title: 'Diversificação: para lá da dependência do petróleo',
      subtitle: 'Renda petrolífera, doença holandesa e os desafios de uma economia mais equilibrada.',
      category: 'Economia Política', author: 'Prof. Carlos Lopes', minutes: 10,
      publishedAt: _daysAgo(0), views: 890, likes: 96, comments: 12, shares: 20, viewGrowth: 95,
    ),
    // ----- Podcasts -----
    FeedContent(
      id: 'p1', type: FeedContentType.podcast, scene: EhScene.podcast,
      title: 'Conversas com História: a economia do café',
      subtitle: 'Episódio 12 · Especialistas debatem o auge e o declínio do café angolano.',
      category: 'Agricultura', author: 'Rádio EH', minutes: 28,
      publishedAt: _daysAgo(3), views: 1620, likes: 240, comments: 18, shares: 44, viewGrowth: 63,
    ),
    FeedContent(
      id: 'p2', type: FeedContentType.podcast, scene: EhScene.podcast,
      title: 'O Kwanza em três atos',
      subtitle: 'Episódio 9 · A história da moeda contada por quem a estuda.',
      category: 'Moeda & Finanças', author: 'Rádio EH', minutes: 22,
      publishedAt: _daysAgo(9), views: 2040, likes: 310, comments: 26, shares: 70, viewGrowth: 30,
    ),
    FeedContent(
      id: 'p3', type: FeedContentType.podcast, scene: EhScene.podcast,
      title: 'Corredores de exportação: Lobito e o mundo',
      subtitle: 'Episódio 7 · Infraestrutura, portos e comércio regional.',
      category: 'Infraestrutura', author: 'Rádio EH', minutes: 31,
      publishedAt: _daysAgo(2), views: 980, likes: 120, comments: 9, shares: 22, viewGrowth: 58,
    ),
    // ----- Quizzes -----
    FeedContent(
      id: 'q1', type: FeedContentType.quiz, scene: EhScene.rubber,
      title: 'Quiz: O café em Angola',
      subtitle: '5 perguntas · Teste o que aprendeu sobre o ciclo do café.',
      category: 'Agricultura', author: 'Equipa EH', minutes: 3,
      publishedAt: _daysAgo(1), views: 1450, likes: 180, comments: 0, shares: 15, viewGrowth: 70,
    ),
    FeedContent(
      id: 'q2', type: FeedContentType.quiz, scene: EhScene.currency,
      title: 'Quiz: A história do Kwanza',
      subtitle: '6 perguntas · Da criação às reformas monetárias.',
      category: 'Moeda & Finanças', author: 'Equipa EH', minutes: 4,
      publishedAt: _daysAgo(4), views: 1210, likes: 140, comments: 0, shares: 11, viewGrowth: 40,
    ),
    FeedContent(
      id: 'q3', type: FeedContentType.quiz, scene: EhScene.market,
      title: 'Quiz: Rotas e comércio',
      subtitle: '5 perguntas · Do Reino do Kongo às ferrovias do século XX.',
      category: 'Comércio', author: 'Equipa EH', minutes: 3,
      publishedAt: _daysAgo(7), views: 760, likes: 88, comments: 0, shares: 7, viewGrowth: 25,
    ),
  ];

  List<FeedContent> get _articles =>
      _catalog.where((c) => c.type == FeedContentType.article || c.type == FeedContentType.jindungo).toList();

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

  /// Número máximo de páginas do feed de descoberta antes do rodapé.
  int get maxDiscoverPages => 4;

  bool hasMoreDiscover(int page) => page < maxDiscoverPages;

  /// Página do feed misto de descoberta, com **diversidade**: evita mostrar
  /// vários conteúdos seguidos da mesma categoria e mistura tipos (artigos,
  /// podcasts, quizzes). Recicla o catálogo com reordenação por semente para
  /// dar a sensação de descoberta contínua (scroll infinito).
  List<FeedEntry> discoverPage(int page, {int seed = 0}) {
    final pageSeed = seed + page * 97;
    final ranked = [..._catalog]..sort((a, b) => (_popularity(b) +
            _recency(b) * 25 +
            _jitter(b, pageSeed) * 60)
        .compareTo(_popularity(a) + _recency(a) * 25 + _jitter(a, pageSeed) * 60));
    final diversified = _diversify(ranked);
    final start = (page * _pageSize) % diversified.length;
    final window = <FeedContent>[];
    for (var i = 0; i < _pageSize; i++) {
      window.add(diversified[(start + i) % diversified.length]);
    }
    return [for (final c in window) FeedEntry(content: c, reason: _discoverReason(c))];
  }

  FeedReason _discoverReason(FeedContent c) {
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
