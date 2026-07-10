import '../models/feed.dart';
import 'backend_service.dart';

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
    final liked = _liked.contains(id);
    // Persiste no backend quando é um gosto novo — o servidor faz upsert e
    // notifica o autor do conteúdo. O des-curtir mantém-se local (o backend
    // não remove favoritos), para não perder a notificação já enviada.
    if (liked) BackendService.instance.favoriteContent(id);
    return liked;
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

  /// Contagem de visualizações apresentada. Usa apenas o valor real do backend:
  /// não inflaciona localmente (antes somava +1 assim que o post ficava visível,
  /// fazendo um conteúdo recém-criado aparecer logo com "1 visualização" para o
  /// próprio autor). Enquanto o backend não expõe visualizações, fica em 0.
  int viewCount(FeedContent c) => c.views;

  // ------------------------------------------------------------- Comentários

  /// Conteúdos cujos comentários já foram carregados do backend (evita recargas).
  final Set<String> _commentsLoaded = {};

  /// Lista de comentários de um conteúdo, já carregada em memória. Vazia até
  /// [loadComments] terminar (a UI chama-o e depois reconstrói-se).
  List<FeedComment> comments(FeedContent c) => _comments.putIfAbsent(c.id, () => []);

  /// Carrega os comentários reais do conteúdo a partir do backend (uma vez por
  /// sessão, exceto [force]). Devolve a lista já em memória.
  Future<List<FeedComment>> loadComments(FeedContent c, {bool force = false}) async {
    if (_commentsLoaded.contains(c.id) && !force) return comments(c);
    final raw = await BackendService.instance.contentComments(c.id);
    final loaded = raw.map(_fromBackend).toList();
    _comments[c.id] = loaded;
    _commentsLoaded.add(c.id);
    return loaded;
  }

  /// Total apresentado = comentários carregados do backend. Enquanto ainda não
  /// carregaram, mostra a contagem base que veio com o conteúdo.
  int commentCount(FeedContent c) {
    if (!_commentsLoaded.contains(c.id)) return c.comments;
    return comments(c).length;
  }

  /// Publica um comentário. Persiste no backend (que notifica o autor) e, em
  /// caso de sucesso, insere-o na lista local. Devolve `true` se persistiu.
  Future<bool> addComment(FeedContent c, String text) async {
    final ok = await BackendService.instance.commentOnContent(contentId: c.id, text: text);
    if (ok) {
      comments(c).insert(
        0,
        FeedComment(author: 'Você', initials: 'EU', text: text.trim(), timeAgo: 'agora', isMine: true),
      );
    }
    return ok;
  }

  FeedComment _fromBackend(Map<String, dynamic> json) {
    final author = json['author'];
    final name = author is Map ? author['name']?.toString() ?? 'Utilizador' : 'Utilizador';
    return FeedComment(
      author: name,
      initials: _initials(name),
      text: json['text']?.toString() ?? '',
      timeAgo: _relative(json['createdAt']?.toString()),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String _relative(String? iso) {
    final date = iso == null ? null : DateTime.tryParse(iso);
    if (date == null) return 'agora';
    final diff = DateTime.now().difference(date.toLocal());
    if (diff.inDays > 0) return 'há ${diff.inDays} dia${diff.inDays == 1 ? '' : 's'}';
    if (diff.inHours > 0) return 'há ${diff.inHours} h';
    if (diff.inMinutes > 0) return 'há ${diff.inMinutes} min';
    return 'agora';
  }
}
