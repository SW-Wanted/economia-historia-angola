import '../models/feed.dart';

/// Um comentário (ou resposta) de uma publicação do feed.
class FeedComment {
  FeedComment({
    required this.author,
    required this.initials,
    required this.text,
    required this.timeAgo,
    this.role,
    this.likes = 0,
    this.isMine = false,
    List<FeedComment>? replies,
  }) : replies = replies ?? [];

  final String author;
  final String initials;
  final String text;
  final String timeAgo;
  final String? role;
  int likes;
  final bool isMine;
  final List<FeedComment> replies;
}

/// Estado local das interações do utilizador com o feed (curtir, guardar,
/// visualizações e comentários). Mantém-se em memória, seguindo o padrão
/// offline-first do projeto — pode depois ser sincronizado com o backend
/// através de endpoints dedicados sem alterar a UI.
///
/// É um armazém simples (sem `ChangeNotifier`): cada widget muta o estado e
/// reconstrói-se localmente com `setState`, mantendo os rebuilds mínimos.
class FeedInteractions {
  FeedInteractions._();

  static final FeedInteractions instance = FeedInteractions._();

  final Set<String> _liked = {};
  final Set<String> _saved = {};
  final Set<String> _viewed = {};
  final Map<String, List<FeedComment>> _comments = {};

  /// Quizzes concluídos → pontuação obtida (%). Semeado com um exemplo.
  final Map<String, int> _completedQuizzes = {'q2': 80};

  // -------------------------------------------------------------- Quizzes

  bool isQuizCompleted(String id) => _completedQuizzes.containsKey(id);

  int quizScore(String id) => _completedQuizzes[id] ?? 0;

  void completeQuiz(String id, int score) => _completedQuizzes[id] = score;

  // ------------------------------------------------------------------ Curtir

  bool isLiked(String id) => _liked.contains(id);

  bool toggleLike(String id) {
    if (!_liked.add(id)) _liked.remove(id);
    return _liked.contains(id);
  }

  /// Total de gostos apresentado = base do conteúdo + gosto do utilizador.
  int likeCount(FeedContent c) => c.likes + (isLiked(c.id) ? 1 : 0);

  // ----------------------------------------------------------------- Guardar

  bool isSaved(String id) => _saved.contains(id);

  bool toggleSave(String id) {
    if (!_saved.add(id)) _saved.remove(id);
    return _saved.contains(id);
  }

  /// Conteúdos guardados na biblioteca pessoal (para futura integração).
  Set<String> get savedIds => Set.unmodifiable(_saved);

  // ------------------------------------------------------------ Visualizações

  bool isViewed(String id) => _viewed.contains(id);

  /// Marca uma visualização única por sessão. Devolve `true` se foi a primeira
  /// vez (para o widget atualizar o contador).
  bool markViewed(String id) => _viewed.add(id);

  int viewCount(FeedContent c) => c.views + (isViewed(c.id) ? 1 : 0);

  // ------------------------------------------------------------- Comentários

  /// Lista de comentários de um conteúdo. Semeada de forma preguiçosa com uma
  /// pequena amostra representativa (as redes sociais carregam por partes).
  List<FeedComment> comments(FeedContent c) => _comments.putIfAbsent(c.id, () => _seed(c));

  /// Total apresentado = base do conteúdo + respostas adicionadas pelo utilizador.
  int commentCount(FeedContent c) {
    final list = comments(c);
    final userAdded = _countUserAdded(list);
    return c.comments + userAdded;
  }

  void addComment(FeedContent c, String text) {
    comments(c).insert(
      0,
      FeedComment(author: 'Você', initials: 'EU', text: text.trim(), timeAgo: 'agora', isMine: true),
    );
  }

  void addReply(FeedContent c, FeedComment parent, String text) {
    comments(c); // garante inicialização
    parent.replies.add(
      FeedComment(author: 'Você', initials: 'EU', text: text.trim(), timeAgo: 'agora', isMine: true),
    );
  }

  int _countUserAdded(List<FeedComment> list) {
    var count = 0;
    for (final c in list) {
      if (c.isMine) count++;
      count += c.replies.where((r) => r.isMine).length;
    }
    return count;
  }

  /// Amostra determinística de comentários por conteúdo (varia com o id/tema).
  List<FeedComment> _seed(FeedContent c) {
    if (c.comments == 0) return [];
    final pool = <FeedComment>[
      FeedComment(
        author: 'Ana Muachia', initials: 'AM', role: 'Historiadora', timeAgo: 'há 1 h', likes: 12,
        text: 'Excelente contextualização — vale ligar isto às rotas comerciais regionais.',
        replies: [
          FeedComment(author: 'João Domingos', initials: 'JD', role: 'Analista', timeAgo: 'há 40 min', likes: 3,
              text: 'Concordo. A infraestrutura define quem participa do mercado.'),
        ],
      ),
      FeedComment(
        author: 'Beatriz Neto', initials: 'BN', role: 'Investigadora', timeAgo: 'há 2 h', likes: 7,
        text: 'Tem fontes sobre o impacto no emprego rural? Gostava de aprofundar.',
      ),
      FeedComment(
        author: 'Dr. Kambinda', initials: 'DK', role: 'Escritor', timeAgo: 'há 3 h', likes: 21,
        text: 'Este é precisamente o tipo de análise que falta no debate público.',
      ),
    ];
    // Número de comentários visíveis proporcional (amostra até 3).
    final take = c.comments >= 3 ? 3 : c.comments;
    return pool.take(take).toList();
  }
}
