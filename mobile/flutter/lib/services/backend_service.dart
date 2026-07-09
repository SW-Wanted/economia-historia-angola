import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/community_category.dart';
import '../models/content_item.dart';
import '../models/content_report.dart';
import '../models/discussion_room.dart';
import '../models/feed.dart';
import '../models/forum_topic.dart';
import '../models/landing_stats.dart';
import '../models/notification_item.dart';
import '../models/profile_stats.dart';
import '../models/ranking_user.dart';
import '../models/quiz_question.dart';
import '../models/weekly_quiz.dart';
import '../widgets/eh_illustration.dart';
import 'api_client.dart';
import 'mock_data_service.dart';
import 'token_store.dart';

class BackendService {
  BackendService._() {
    // O ApiClient delega a renovação da sessão ao BackendService quando um
    // pedido devolve 401 (access token expirado, TTL de 15 min).
    _api.onUnauthorized = _refreshSession;
  }

  static final BackendService instance = BackendService._();

  final ApiClient _api = ApiClient();
  final MockDataService _fallback = const MockDataService();
  AppUser? _currentUser;

  bool get isAuthenticated => _api.isAuthenticated;

  /// Recarrega a sessão persistida (chamado no arranque, a partir do splash).
  /// Devolve o utilizador autenticado se os tokens ainda forem válidos, ou
  /// `null` se não houver sessão guardada ou já tiver expirado.
  Future<AppUser?> restoreSession() async {
    final saved = await TokenStore.read();
    if (saved.refreshToken == null) return null;
    _api.accessToken = saved.accessToken;
    _api.refreshToken = saved.refreshToken;
    try {
      _currentUser = _userFromProfile(await _api.getJson('/users/me'));
      return _currentUser;
    } catch (_) {
      // Tokens inválidos/expirados: limpa a sessão para não bloquear o arranque.
      await logout();
      return null;
    }
  }

  /// Renova o par de tokens usando o refresh token (rotação no backend).
  /// Invocado automaticamente pelo [ApiClient] ao receber 401.
  Future<void> _refreshSession() async {
    final refresh = _api.refreshToken;
    if (refresh == null) return;
    final json = await _api.postJson('/auth/refresh', {'refreshToken': refresh});
    await _storeTokens(json);
  }

  /// Utilizador anónimo mínimo (perfil de menor privilégio). Usado como
  /// fallback síncrono quando ainda não há sessão real carregada — NUNCA um
  /// perfil com privilégios, para não expor UI de gestão a quem não é.
  static const AppUser _anonymous = AppUser(
    name: 'Convidado',
    initials: 'C',
    role: UserRole.utilizador,
    course: '',
    institution: '',
    province: '',
  );

  /// Utilizador autenticado em cache. Se ainda não houver sessão real, devolve
  /// o [_anonymous] (utilizador comum) — e não um mock com privilégios — para
  /// que as telas síncronas nunca mostrem funcionalidades de Escritor/Admin/
  /// Super Admin a quem não tem esse papel.
  AppUser get cachedUser => _currentUser ?? _anonymous;

  Future<AppUser> login({required String email, required String password}) async {
    final json = await _api.postJson('/auth/login', {
      'email': email.trim().toLowerCase(),
      'password': password.trim(),
    });
    await _storeTokens(json);
    _currentUser = await _resolveProfile(json['user'] as Map<String, dynamic>?);
    return _currentUser!;
  }

  /// Cria sempre uma conta de utilizador comum (USER). A candidatura a escritor,
  /// quando aplicável, é enviada à parte via [submitWriterApplication] depois de
  /// a sessão estar autenticada.
  Future<AppUser> register({required String name, required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    final username = normalizedEmail.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '').toLowerCase();
    final json = await _api.postJson('/auth/register', {
      'name': name.trim(),
      'email': normalizedEmail,
      'username': username.isEmpty ? 'utilizador' : username,
      'password': password,
    });
    await _storeTokens(json);
    _currentUser = await _resolveProfile(json['user'] as Map<String, dynamic>?);
    return _currentUser!;
  }

  /// Submete uma candidatura a escritor para um utilizador já autenticado.
  /// Usado logo após o cadastro (quando o switch está ligado) e também quando
  /// alguém já registado decide candidatar-se mais tarde. Não concede
  /// permissões — fica pendente de aprovação.
  Future<Map<String, dynamic>> submitWriterApplication(Map<String, dynamic> application) {
    return _api.postJson('/writer-applications', application);
  }

  /// Devolve a candidatura de escritor do utilizador autenticado, ou `null`
  /// se ainda não existir nenhuma.
  Future<Map<String, dynamic>?> myWriterApplication() async {
    try {
      final json = await _api.getJson('/writer-applications/me');
      return json.isEmpty ? null : json;
    } catch (_) {
      return null;
    }
  }

  /// Após autenticar, busca o perfil completo (/users/me) para obter o nome
  /// real e o papel; se falhar, usa os dados do payload de autenticação.
  Future<AppUser> _resolveProfile(Map<String, dynamic>? authUser) async {
    try {
      return _userFromProfile(await _api.getJson('/users/me'));
    } catch (_) {
      return _userFromAuth(authUser);
    }
  }

  Future<AppUser> currentUser() async {
    if (!isAuthenticated) return _anonymous;
    if (_currentUser != null) return _currentUser!;
    try {
      final json = await _api.getJson('/users/me');
      _currentUser = _userFromProfile(json);
      return _currentUser!;
    } catch (_) {
      // Falha a obter o perfil: devolve o perfil de menor privilégio, nunca um
      // mock com poderes de gestão.
      return _anonymous;
    }
  }

  /// Estatísticas reais do perfil (pontos, ranking, conteúdos concluídos,
  /// quizzes). Devolve `null` se não houver sessão ou o backend estiver
  /// inacessível — o perfil esconde a secção nesse caso.
  Future<ProfileStats?> profileStats() async {
    if (!isAuthenticated) return null;
    try {
      return ProfileStats.fromJson(await _api.getJson('/users/me/stats'));
    } catch (_) {
      return null;
    }
  }

  /// Interesses e comunidades reais do utilizador autenticado, extraídos de
  /// `/users/me`. Listas vazias quando não há sessão/dados.
  Future<({List<String> interests, List<String> communities})> myProfileExtras() async {
    if (!isAuthenticated) return (interests: const <String>[], communities: const <String>[]);
    try {
      final json = await _api.getJson('/users/me');
      final interestsRaw = json['interests']?.toString() ?? '';
      final interests = interestsRaw
          .split(',')
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toList();
      final memberships = json['memberships'];
      final communities = memberships is List
          ? memberships
              .whereType<Map<String, dynamic>>()
              .map((membership) {
                final community = membership['community'];
                return community is Map ? community['name']?.toString() : null;
              })
              .whereType<String>()
              .toList()
          : <String>[];
      return (interests: interests, communities: communities);
    } catch (_) {
      return (interests: const <String>[], communities: const <String>[]);
    }
  }

  /// Carrega uma imagem (bytes) para o storage e devolve o URL público final.
  /// Fluxo: pede um presign ao backend, faz o PUT direto para o storage e
  /// devolve o `publicUrl`. Requer sessão autenticada.
  Future<String> uploadImage({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    return uploadFile(bytes: bytes, filename: filename, mimeType: mimeType);
  }

  Future<String> uploadFile({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final presign = await _api.postJson('/uploads/presign', {
      'filename': filename,
      'mimeType': mimeType,
      'sizeBytes': bytes.length,
    });
    final uploadUrl = presign['uploadUrl']?.toString();
    final publicUrl = presign['publicUrl']?.toString();
    if (uploadUrl == null || publicUrl == null) {
      throw const ApiException('Resposta de upload inválida do servidor.');
    }
    final http.Response response;
    try {
      response = await http
          .put(
            Uri.parse(uploadUrl),
            headers: {'Content-Type': mimeType},
            body: bytes,
          )
          .timeout(const Duration(minutes: 3));
    } on TimeoutException {
      final mb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
      throw ApiException(
        'O envio do ficheiro ($mb MB) demorou demasiado. Ficheiros grandes podem exceder o tempo limite; '
        'tente um ficheiro mais pequeno ou uma ligação mais rápida.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(_uploadErrorMessage(response, mimeType, bytes.length), statusCode: response.statusCode);
    }
    return publicUrl;
  }

  /// Traduz a resposta de erro do storage (Supabase) numa mensagem acionável.
  /// O `413` significa que o ficheiro excede o limite do bucket; um `400`/`415`
  /// costuma indicar que o tipo (ex.: vídeo) não está permitido no bucket.
  String _uploadErrorMessage(http.Response response, String mimeType, int sizeBytes) {
    final mb = (sizeBytes / (1024 * 1024)).toStringAsFixed(1);
    if (response.statusCode == 413) {
      return 'O ficheiro ($mb MB) excede o limite de tamanho do armazenamento. '
          'Aumente o "file size limit" do bucket no Supabase ou use um ficheiro menor.';
    }
    if (response.statusCode == 400 || response.statusCode == 415) {
      return 'O tipo de ficheiro ($mimeType) não é aceite pelo armazenamento. '
          'Permita este tipo em "Allowed MIME types" do bucket no Supabase.';
    }
    // 5xx (ex.: 524 do Cloudflare) em ficheiros grandes = o envio demorou demais.
    if (response.statusCode >= 500) {
      return 'O envio do ficheiro ($mb MB) falhou no servidor de armazenamento '
          '(erro ${response.statusCode}). Ficheiros grandes podem exceder o tempo '
          'limite — tente um ficheiro mais pequeno ou uma ligação mais rápida.';
    }
    return 'Falha ao enviar o ficheiro (erro ${response.statusCode}).';
  }

  Future<FeedContent> createContent({
    required String title,
    required String type,
    required String summary,
    required String body,
    required String category,
    String? sourceUrl,
    String? mediaUrl,
    String? thumbnailUrl,
    bool isJindungo = false,
    bool exclusive = false,
  }) async {
    final json = await _api.postJson('/contents', {
      'title': title.trim(),
      'slug': _slugFor(title),
      'type': type,
      'summary': summary.trim().isEmpty ? body.trim() : summary.trim(),
      'body': body.trim(),
      'sourceUrl': sourceUrl,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'visibility': isJindungo || exclusive ? 'AUTHENTICATED' : 'PUBLIC',
      'isJindungo': isJindungo,
      'categoryName': category,
    });
    return _feedFromContent(json);
  }

  Future<CommunityCategory> createCommunity({
    required String name,
    required String description,
    required bool isPrivate,
  }) async {
    final json = await _api.postJson('/communities', {
      'name': name.trim(),
      'slug': _slugFor(name),
      'description': description.trim(),
      'type': isPrivate ? 'PRIVATE' : 'PUBLIC',
    });
    return _communityFromJson(json);
  }

  Future<List<CommunityCategory>> communities() async {
    final list = await _api.getList('/communities');
    return list.whereType<Map<String, dynamic>>().map(_communityFromJson).toList();
  }

  /// Detalhe de uma comunidade (inclui estado de adesão e fóruns/tópicos).
  Future<CommunityCategory> communityDetail(String id) async {
    return _communityFromJson(await _api.getJson('/communities/$id'));
  }

  /// Fóruns públicos de uma comunidade (usados como "tópicos" no mobile).
  Future<List<Map<String, dynamic>>> communityForums(String id) async {
    final json = await _api.getJson('/communities/$id');
    final forums = json['forums'];
    if (forums is! List) return const [];
    return forums.whereType<Map<String, dynamic>>().toList();
  }

  /// Pedido de adesão. O backend cria a adesão como PENDING (aprovação por
  /// moderador/dono) — devolvemos o estado resultante para a UI refletir.
  Future<CommunityViewerStatus> joinCommunity(String id) async {
    final json = await _api.postJson('/communities/$id/join', const {});
    return communityViewerStatusFrom(json['status']);
  }

  Future<void> leaveCommunity(String id) async {
    await _api.delete('/communities/$id/membership');
  }

  // ------------------------------------------------------- Salas privadas

  Future<List<DiscussionRoom>> rooms() async {
    final list = await _api.getList('/comments/rooms');
    return list.whereType<Map<String, dynamic>>().map(DiscussionRoom.fromJson).toList();
  }

  Future<DiscussionRoom> createRoom({required String name, String? description}) async {
    final json = await _api.postJson('/comments/rooms', {
      'name': name.trim(),
      if (description != null && description.trim().isNotEmpty) 'description': description.trim(),
    });
    return DiscussionRoom.fromJson(json);
  }

  Future<DiscussionRoom> roomDetail(String roomId) async {
    return DiscussionRoom.fromJson(await _api.getJson('/comments/rooms/$roomId/detail'));
  }

  Future<List<RoomParticipant>> roomParticipants(String roomId) async {
    final json = await _api.getJson('/comments/rooms/$roomId/detail');
    final list = json['participants'];
    if (list is! List) return const [];
    return list.whereType<Map<String, dynamic>>().map(RoomParticipant.fromJson).toList();
  }

  Future<List<RoomMessage>> roomMessages(String roomId) async {
    final list = await _api.getList('/comments/rooms/$roomId');
    return list.whereType<Map<String, dynamic>>().map(RoomMessage.fromJson).toList();
  }

  Future<void> sendRoomMessage({required String roomId, required String text}) async {
    await _api.postJson('/comments', {'roomId': roomId, 'text': text.trim()});
  }

  Future<void> inviteRoomParticipant({required String roomId, required String email}) async {
    await _api.postJson('/comments/rooms/$roomId/invite', {'email': email.trim().toLowerCase()});
  }

  Future<void> removeRoomParticipant({required String roomId, required String userId}) async {
    await _api.delete('/comments/rooms/$roomId/participants/$userId');
  }

  Future<void> createForumTopic({
    required String title,
    required String body,
    required String category,
    required bool isPrivate,
    String? communityId,
  }) async {
    final forum = await _api.postJson('/forums', {
      'name': category.trim().isEmpty ? 'Fórum geral' : category.trim(),
      'slug': _slugFor('${category.trim().isEmpty ? 'forum' : category}-${DateTime.now().millisecondsSinceEpoch}'),
      'description': 'Debates sobre ${category.trim().isEmpty ? 'Economia com História' : category.trim()}.',
      'visibility': isPrivate ? 'PRIVATE' : 'PUBLIC',
      if (communityId != null) 'communityId': communityId,
    });
    final forumId = forum['id']?.toString();
    if (forumId == null || forumId.isEmpty) {
      throw const ApiException('Não foi possível criar o fórum.');
    }
    await _api.postJson('/forums/$forumId/topics', {
      'title': title.trim(),
      'slug': _slugFor(title),
      'body': body.trim(),
      'visibility': isPrivate ? 'PRIVATE' : 'PUBLIC',
    });
  }

  Future<WeeklyQuiz> createQuiz({
    required String title,
    required String description,
    required List<Map<String, dynamic>> questions,
    bool isWeekly = false,
  }) async {
    final json = await _api.postJson('/quizzes', {
      'title': title.trim(),
      'slug': _slugFor(title),
      'description': description.trim(),
      'visibility': 'PUBLIC',
      'isWeekly': isWeekly,
      'questions': questions,
    });
    return WeeklyQuiz.fromJson(json);
  }

  Future<WeeklyQuiz> quizById(String id) async {
    return WeeklyQuiz.fromJson(await _api.getJson('/quizzes/$id'));
  }

  /// Carrega um quiz para edição (inclui a opção correta). Requer QUIZ_MANAGE.
  Future<WeeklyQuiz> quizForEdit(String id) async {
    return WeeklyQuiz.fromJson(await _api.getJson('/quizzes/$id/edit'));
  }

  /// Gera perguntas por IA (Gemini) no backend a partir de um tema/conteúdo.
  Future<List<QuizQuestion>> generateQuizQuestions({
    required String title,
    required String category,
    String? context,
    int count = 5,
    String difficulty = 'Médio',
  }) async {
    final json = await _api.postJson('/quizzes/generate', {
      'title': title.trim(),
      'category': category.trim(),
      if (context != null && context.trim().isNotEmpty) 'context': context.trim(),
      'count': count,
      'difficulty': difficulty,
    });
    final raw = json['questions'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().map((q) {
      final opts = q['options'];
      final options = opts is List ? opts.whereType<Map<String, dynamic>>().toList() : <Map<String, dynamic>>[];
      final correctIndex = options.indexWhere((o) => o['isCorrect'] == true);
      return QuizQuestion(
        question: q['statement']?.toString() ?? '',
        options: [for (final o in options) o['text']?.toString() ?? ''],
        correctIndex: correctIndex < 0 ? 0 : correctIndex,
        explanation: q['explanation']?.toString() ?? '',
      );
    }).toList();
  }

  /// Atualiza um quiz existente (título e/ou perguntas). Substitui as perguntas
  /// quando `questions` é fornecido.
  Future<WeeklyQuiz> updateQuiz({
    required String id,
    String? title,
    String? description,
    List<Map<String, dynamic>>? questions,
  }) async {
    final json = await _api.patchJson('/quizzes/$id', {
      if (title != null) 'title': title.trim(),
      if (description != null) 'description': description.trim(),
      if (questions != null) 'questions': questions,
    });
    return WeeklyQuiz.fromJson(json);
  }

  /// Inicia uma tentativa de quiz e devolve o id da tentativa.
  Future<String> startQuizAttempt(String quizId) async {
    final json = await _api.postJson('/quizzes/$quizId/start', const {});
    final id = json['id']?.toString();
    if (id == null || id.isEmpty) {
      throw const ApiException('Não foi possível iniciar o quiz.');
    }
    return id;
  }

  Future<void> answerQuizQuestion({
    required String attemptId,
    required String questionId,
    required String optionId,
  }) async {
    await _api.postJson('/quizzes/attempts/$attemptId/answers', {
      'questionId': questionId,
      'optionId': optionId,
    });
  }

  /// Submete a tentativa; devolve a pontuação autoritativa do servidor.
  Future<int> submitQuizAttempt(String attemptId) async {
    final json = await _api.postJson('/quizzes/attempts/$attemptId/submit', const {});
    return int.tryParse(json['score']?.toString() ?? '') ?? 0;
  }

  String _slugFor(String title) {
    final base = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return '${base.isEmpty ? 'conteudo' : base}-${DateTime.now().millisecondsSinceEpoch}';
  }

  CommunityCategory _communityFromJson(Map<String, dynamic> json) {
    final count = json['_count'];
    return CommunityCategory(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? 'Comunidade',
      description: json['description']?.toString() ?? '',
      topics: count is Map ? int.tryParse(count['forums']?.toString() ?? '') ?? 0 : 0,
      members: count is Map ? int.tryParse(count['memberships']?.toString() ?? '') ?? 0 : 0,
      private: json['type']?.toString() == 'PRIVATE',
      viewerStatus: communityViewerStatusFrom(json['viewerStatus']),
    );
  }

  /// Atualiza o perfil do utilizador (nome, bio, localização, foto, capa,
  /// interesses…) via `PATCH /users/me`. Atualiza também a cache local.
  Future<void> updateProfile(Map<String, dynamic> changes) async {
    await _api.patchJson('/users/me', changes);
    // Recarrega o perfil para refletir as alterações na app imediatamente.
    try {
      _currentUser = _userFromProfile(await _api.getJson('/users/me'));
    } catch (_) {
      // Mantém a cache atual se a releitura falhar.
    }
  }

  Future<List<ContentItem>> contents({String? search}) async {
    try {
      final list = await _api.getList('/contents', query: {'search': search});
      // Backend disponível: mostra sempre o que ele devolve, mesmo que vazio.
      // O mock só entra em ação quando o backend está inacessível (catch).
      return list.whereType<Map<String, dynamic>>().map(_contentFromJson).toList();
    } catch (_) {
      return _fallback.contents();
    }
  }

  /// Catálogo unificado do backend (conteúdos + tópicos de fórum + quizzes)
  /// mapeado para [FeedContent], alimentando o feed, o Explorar, o Fórum e os
  /// Quizzes. Devolve **lista vazia** quando o backend está sem conteúdos ou
  /// inacessível — não recorre a mocks (as telas mostram o estado "sem
  /// conteúdos disponíveis").
  Future<List<FeedContent>> feedCatalog() async {
    final results = await Future.wait([
      _catalogContents(),
      _catalogForumTopics(),
      _catalogQuizzes(),
    ]);
    return [for (final list in results) ...list];
  }

  /// Número máximo de conteúdos carregados para o motor de recomendação.
  /// O feed rankeia/diversifica em memória, por isso carregamos o conjunto de
  /// trabalho por páginas (até este teto) em vez de só a 1ª página de 20.
  static const int _catalogMaxItems = 300;
  static const int _catalogPageSize = 100;

  Future<List<FeedContent>> _catalogContents() async {
    try {
      final all = <Map<String, dynamic>>[];
      var page = 1;
      while (all.length < _catalogMaxItems) {
        final json = await _api.getJson('/contents', query: {
          'page': '$page',
          'limit': '$_catalogPageSize',
        });
        final items = json['items'];
        final pageItems = items is List ? items.whereType<Map<String, dynamic>>().toList() : const <Map<String, dynamic>>[];
        all.addAll(pageItems);
        final total = int.tryParse(json['total']?.toString() ?? '') ?? all.length;
        if (pageItems.length < _catalogPageSize || all.length >= total) break;
        page++;
      }
      return all.map(_feedFromContent).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<FeedContent>> _catalogForumTopics() async {
    try {
      final forums = await _api.getList('/forums');
      if (forums.isEmpty) return const [];
      final results = <FeedContent>[];
      for (final forum in forums.whereType<Map<String, dynamic>>()) {
        final topics = await _api.getList('/forums/${forum['id']}/topics');
        results.addAll(
          topics.whereType<Map<String, dynamic>>().map((topic) => _feedFromTopic(topic, forum)),
        );
      }
      return results;
    } catch (_) {
      return const [];
    }
  }

  Future<List<FeedContent>> _catalogQuizzes() async {
    try {
      final list = await _api.getList('/quizzes');
      return list.whereType<Map<String, dynamic>>().map(_feedFromQuiz).toList();
    } catch (_) {
      return const [];
    }
  }

  FeedContent _feedFromContent(Map<String, dynamic> json) {
    final type = json['type']?.toString().toLowerCase() ?? '';
    final category = json['category'];
    final author = json['author'];
    final categoryName = category is Map ? category['name']?.toString() : null;
    final isJindungo = json['isJindungo'] == true;
    final feedType = isJindungo
        ? FeedContentType.jindungo
        : type.contains('video')
            ? FeedContentType.video
            : type.contains('audio') || type.contains('podcast')
                ? FeedContentType.podcast
                : FeedContentType.article;
    return FeedContent(
      id: json['id']?.toString() ?? json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Conteúdo',
      subtitle: json['summary']?.toString() ?? json['description']?.toString() ?? '',
      category: categoryName ?? 'Conteúdo',
      type: feedType,
      // A ilustração de fundo segue o tipo (ex.: podcast → microfone); só quando
      // o tipo não define uma cena própria é que recorre à categoria editorial.
      scene: _sceneForType(feedType) ?? _sceneFor(categoryName ?? type),
      author: _authorName(author, fallback: json['authorName']?.toString() ?? 'Economia com História'),
      minutes: int.tryParse(json['estimatedMinutes']?.toString() ?? '') ?? 5,
      publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      // Conteúdo PUBLIC ou AUTHENTICATED é visível a qualquer utilizador logado;
      // só o Jindungo (acesso controlado) fica realmente bloqueado no feed.
      locked: isJindungo,
      community: null,
      mediaUrl: (json['mediaUrl']?.toString().isNotEmpty ?? false) ? json['mediaUrl'].toString() : null,
      sourceUrl: (json['sourceUrl']?.toString().isNotEmpty ?? false) ? json['sourceUrl'].toString() : null,
      body: (json['body']?.toString().isNotEmpty ?? false) ? json['body'].toString() : null,
      imageUrl: (json['thumbnailUrl']?.toString().isNotEmpty ?? false) ? json['thumbnailUrl'].toString() : null,
    );
  }

  FeedContent _feedFromTopic(Map<String, dynamic> json, Map<String, dynamic> forum) {
    final author = json['author'];
    final isPrivate = json['visibility']?.toString() == 'PRIVATE';
    return FeedContent(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Tópico',
      subtitle: json['body']?.toString() ?? '',
      category: forum['name']?.toString() ?? 'Fórum',
      type: FeedContentType.forum,
      scene: EhScene.market,
      author: author is Map ? author['name']?.toString() ?? 'Utilizador' : 'Utilizador',
      minutes: 2,
      publishedAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      community: forum['name']?.toString(),
      communityPrivate: isPrivate,
    );
  }

  FeedContent _feedFromQuiz(Map<String, dynamic> json) {
    final category = json['category'];
    final categoryName = category is Map ? category['name']?.toString() : null;
    return FeedContent(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Quiz',
      subtitle: json['description']?.toString() ?? json['summary']?.toString() ?? '',
      category: categoryName ?? 'Quiz',
      type: FeedContentType.quiz,
      scene: _sceneFor(categoryName ?? 'quiz'),
      author: json['authorName']?.toString() ?? 'Equipa EH',
      minutes: 3,
      publishedAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  /// Cena própria de um tipo de conteúdo, quando existe (ex.: podcast/áudio →
  /// microfone). Devolve `null` para tipos sem ilustração dedicada, deixando a
  /// escolha recair na categoria editorial.
  EhScene? _sceneForType(FeedContentType type) => switch (type) {
        FeedContentType.podcast => EhScene.podcast,
        _ => null,
      };

  /// Escolhe uma ilustração coerente com a categoria/tipo do conteúdo.
  EhScene _sceneFor(String hint) {
    final value = hint.toLowerCase();
    if (value.contains('moeda') || value.contains('finan') || value.contains('kwanza')) return EhScene.currency;
    if (value.contains('coloni') || value.contains('polít') || value.contains('petról') || value.contains('institu')) {
      return EhScene.institution;
    }
    if (value.contains('mapa') || value.contains('regi') || value.contains('provín')) return EhScene.map;
    if (value.contains('agric') || value.contains('café') || value.contains('rural')) return EhScene.rubber;
    if (value.contains('podcast') || value.contains('áudio') || value.contains('audio')) return EhScene.podcast;
    return EhScene.market;
  }

  /// Contagens reais de uma província (conteúdos + autores) para o mapa.
  /// Devolve zeros quando a província não tem dados ou o backend está
  /// inacessível — nunca valores fictícios.
  Future<({int contents, int authors})> provinceStats(String name) async {
    try {
      final json = await _api.getJson('/stats/province/${Uri.encodeComponent(name)}');
      return (
        contents: int.tryParse(json['contents']?.toString() ?? '') ?? 0,
        authors: int.tryParse(json['authors']?.toString() ?? '') ?? 0,
      );
    } catch (_) {
      return (contents: 0, authors: 0);
    }
  }

  /// Contagens reais para a secção "A comunidade em números" da landing.
  /// Devolve `null` quando o backend está inacessível, para a landing poder
  /// manter os valores estáticos de apresentação (offline-first).
  Future<LandingStats?> landingStats() async {
    try {
      final json = await _api.getJson('/stats/landing');
      return LandingStats(
        members: int.tryParse(json['members']?.toString() ?? '') ?? 0,
        contents: int.tryParse(json['contents']?.toString() ?? '') ?? 0,
        quizzes: int.tryParse(json['quizzes']?.toString() ?? '') ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  /// "Quiz da Semana" em destaque, ou `null` se nenhum admin marcou um quiz
  /// como semanal (ou o backend está inacessível). As telas não mostram o
  /// cartão de destaque quando é `null`.
  Future<WeeklyQuiz?> weeklyQuiz() async {
    try {
      final json = await _api.getJson('/quizzes/weekly');
      // O backend devolve `null` quando não há quiz semanal; o ApiClient
      // converte isso num mapa vazio ({items: null}) — sem `id` real.
      if (json['id'] == null) return null;
      final quiz = WeeklyQuiz.fromJson(json);
      return quiz.hasQuestions ? quiz : null;
    } catch (_) {
      return null;
    }
  }

  Future<List<ForumTopic>> forumTopics() async {
    try {
      final forums = await _api.getList('/forums');
      // Sem fóruns no backend: ainda assim é uma resposta válida (lista vazia).
      if (forums.isEmpty) return const [];
      final forum = forums.first as Map<String, dynamic>;
      final topics = await _api.getList('/forums/${forum['id']}/topics');
      return topics.whereType<Map<String, dynamic>>().map(_topicFromJson).toList();
    } catch (_) {
      return _fallback.topics();
    }
  }

  Future<List<RankingUser>> ranking() async {
    try {
      final list = await _api.getList('/quizzes/rankings');
      return list.whereType<Map<String, dynamic>>().map(_rankingFromJson).where((user) => !_isMockRankingUser(user)).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<NotificationItem>> notifications() async {
    if (!isAuthenticated) return _fallback.notifications();
    try {
      final list = await _api.getList('/notifications');
      return list.whereType<Map<String, dynamic>>().map(_notificationFromJson).toList();
    } catch (_) {
      return _fallback.notifications();
    }
  }

  /// Marca uma notificação como lida. `id` nulo (itens mock) é ignorado.
  Future<void> markNotificationRead(String? id) async {
    if (!isAuthenticated || id == null || id.isEmpty) return;
    await _api.patchJson('/notifications/$id/read', const {});
  }

  Future<void> markAllNotificationsRead() async {
    if (!isAuthenticated) return;
    await _api.patchJson('/notifications/read-all', const {});
  }

  Future<List<ContentReport>> reports() async {
    if (!isAuthenticated) return _fallback.reports();
    try {
      final list = await _api.getList('/reports');
      return list.whereType<Map<String, dynamic>>().map(_reportFromJson).toList();
    } catch (_) {
      return _fallback.reports();
    }
  }

  Future<void> reviewReport(String id, {required bool remove}) async {
    await _api.patchJson('/reports/$id/review', {
      'status': remove ? 'RESOLVED' : 'DISMISSED',
      'resolution': remove ? 'Conteudo removido pela moderacao mobile.' : 'Denuncia descartada pelo mobile.',
    });
  }

  Future<void> forgotPassword(String email) async {
    await _api.postJson('/auth/forgot-password', {'email': email.trim()});
  }

  /// Termina a sessão no backend (best-effort) e limpa o estado local.
  Future<void> logout() async {
    final refresh = _api.refreshToken;
    try {
      if (refresh != null) {
        await _api.postJson('/auth/logout', {'refreshToken': refresh});
      }
    } catch (_) {
      // Mesmo que o backend falhe, limpamos a sessão localmente.
    }
    _api.accessToken = null;
    _api.refreshToken = null;
    _currentUser = null;
    await TokenStore.clear();
  }

  Future<void> _storeTokens(Map<String, dynamic> json) async {
    _api.accessToken = json['accessToken']?.toString();
    _api.refreshToken = json['refreshToken']?.toString();
    await TokenStore.write(
      accessToken: _api.accessToken,
      refreshToken: _api.refreshToken,
    );
  }

  AppUser _userFromAuth(Map<String, dynamic>? json) {
    final email = json?['email']?.toString() ?? '';
    return AppUser(
      name: email.isEmpty ? 'Utilizador' : email.split('@').first,
      initials: _initials(email),
      role: _roleFromBackend(json?['roles']),
      course: 'Economia',
      email: email,
    );
  }

  AppUser _userFromProfile(Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? json['username']?.toString() ?? 'Utilizador';
    final province = json['province']?.toString();
    final bio = json['bio']?.toString();
    return AppUser(
      name: name,
      initials: _initials(name),
      role: _roleFromBackend((json['roles'] as List?)?.map((item) {
        if (item is Map && item['role'] is Map) return item['role']['code'];
        return item;
      }).toList()),
      course: json['school']?.toString() ?? 'Economia',
      email: json['email']?.toString() ?? '',
      // Só usa valores reais; sem inventar província/bio quando o backend não os tem.
      province: (province != null && province.isNotEmpty) ? province : '',
      bio: (bio != null && bio.trim().isNotEmpty) ? bio.trim() : null,
      memberSince: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      avatarUrl: (json['avatarUrl']?.toString().isNotEmpty ?? false) ? json['avatarUrl'].toString() : null,
      coverUrl: (json['coverUrl']?.toString().isNotEmpty ?? false) ? json['coverUrl'].toString() : null,
    );
  }

  ContentItem _contentFromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final categoryName = category is Map ? category['name']?.toString() : null;
    final body = json['body']?.toString() ?? json['summary']?.toString() ?? '';
    return ContentItem(
      title: json['title']?.toString() ?? 'Conteudo',
      subtitle: json['summary']?.toString() ?? json['description']?.toString() ?? '',
      category: categoryName ?? json['type']?.toString() ?? 'Conteudo',
      minutes: int.tryParse(json['estimatedMinutes']?.toString() ?? '') ?? 5,
      icon: _iconForType(json['type']?.toString(), categoryName),
      locked: json['visibility']?.toString() != 'PUBLIC',
      featured: json['featured'] == true,
      author: _authorName(json['author'], fallback: json['authorName']?.toString() ?? 'Economia com Historia'),
      province: json['province']?.toString(),
      body: body.isEmpty ? const [] : body.split('\n').where((line) => line.trim().isNotEmpty).toList(),
    );
  }

  ForumTopic _topicFromJson(Map<String, dynamic> json) {
    final author = json['author'];
    final count = json['_count'];
    return ForumTopic(
      title: json['title']?.toString() ?? 'Topico',
      author: author is Map ? author['name']?.toString() ?? 'Utilizador' : 'Utilizador',
      comments: count is Map ? int.tryParse(count['replies']?.toString() ?? '') ?? 0 : 0,
      tag: json['visibility']?.toString() == 'PRIVATE' ? 'Privado' : 'Publico',
      private: json['visibility']?.toString() == 'PRIVATE',
      excerpt: json['body']?.toString() ?? '',
      timeAgo: _relativeTime(json['createdAt']?.toString()),
    );
  }

  RankingUser _rankingFromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final name = user is Map ? user['name']?.toString() ?? 'Utilizador' : 'Utilizador';
    final score = int.tryParse(json['score']?.toString() ?? '') ?? 0;
    // Província e instituição reais vêm do utilizador (region/school); ficam
    // vazias quando o backend não as tem — sem inventar valores.
    final province = user is Map ? user['region']?.toString() ?? '' : '';
    final institution = user is Map ? user['school']?.toString() ?? '' : '';
    return RankingUser(
      name: name,
      points: score,
      // Sem nível fictício: o backend ainda não devolve classificações.
      level: '',
      initials: _initials(name),
      province: province,
      institution: institution,
    );
  }

  NotificationItem _notificationFromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? 'Notificacao',
      body: json['body']?.toString() ?? '',
      timeAgo: _relativeTime(json['createdAt']?.toString()),
      kind: _notificationKind(json['type']?.toString()),
      unread: json['readAt'] == null,
    );
  }

  ContentReport _reportFromJson(Map<String, dynamic> json) {
    return ContentReport(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? 'Conteudo denunciado',
      target: json['topicId'] != null
          ? ReportTarget.topic
          : json['commentId'] != null || json['replyId'] != null
              ? ReportTarget.comment
              : ReportTarget.content,
      reason: _reportReason(json['reason']?.toString()),
      excerpt: json['details']?.toString() ?? json['reason']?.toString() ?? '',
      timeAgo: _relativeTime(json['createdAt']?.toString()),
    );
  }

  UserRole _roleFromBackend(dynamic roles) {
    final values = roles is List ? roles.map((role) => role.toString()).toSet() : <String>{};
    if (values.contains('SUPER_ADMIN')) return UserRole.superAdmin;
    if (values.contains('ADMIN')) return UserRole.admin;
    // 'PROFESSOR' do backend mapeia para Escritor (publica conteudos) no modelo de 4 perfis.
    if (values.contains('PROFESSOR') || values.contains('WRITER')) return UserRole.escritor;
    return UserRole.utilizador;
  }

  IconData _iconForType(String? type, String? category) {
    final value = '${type ?? ''} ${category ?? ''}'.toLowerCase();
    if (value.contains('quiz')) return Icons.quiz_outlined;
    if (value.contains('video')) return Icons.play_circle_outline;
    if (value.contains('jindungo')) return Icons.local_fire_department_outlined;
    if (value.contains('audio') || value.contains('podcast')) return Icons.mic_none_outlined;
    return Icons.menu_book_outlined;
  }

  String _authorName(dynamic author, {required String fallback}) {
    if (author is Map) {
      final name = author['name']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return fallback;
  }

  bool _isMockRankingUser(RankingUser user) {
    final name = user.name.trim().toLowerCase();
    if (name.isEmpty || name.startsWith('mock ')) return true;
    // Contas de teste/seed (ex.: "Stats Teste", "Stats Test", "Escritor Teste")
    // não devem aparecer no ranking real. Considera qualquer nome que combine
    // um marcador de teste ("test"/"teste") — em PT e EN — como fictício.
    return name.contains('teste') || name.contains('test');
  }

  NotificationKind _notificationKind(String? type) {
    final value = type?.toLowerCase() ?? '';
    if (value.contains('quiz')) return NotificationKind.quiz;
    if (value.contains('forum') || value.contains('reply')) return NotificationKind.forum;
    if (value.contains('content')) return NotificationKind.content;
    if (value.contains('access')) return NotificationKind.access;
    return NotificationKind.system;
  }

  ReportReason _reportReason(String? reason) {
    final value = reason?.toLowerCase() ?? '';
    if (value.contains('spam')) return ReportReason.spam;
    if (value.contains('misinformation') || value.contains('false')) return ReportReason.misinformation;
    if (value.contains('partisan')) return ReportReason.partisan;
    if (value.contains('offensive') || value.contains('hate')) return ReportReason.offensive;
    return ReportReason.other;
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _relativeTime(String? iso) {
    final date = iso == null ? null : DateTime.tryParse(iso);
    if (date == null) return 'agora';
    final diff = DateTime.now().difference(date.toLocal());
    if (diff.inDays > 0) return 'ha ${diff.inDays} dia${diff.inDays == 1 ? '' : 's'}';
    if (diff.inHours > 0) return 'ha ${diff.inHours} hora${diff.inHours == 1 ? '' : 's'}';
    if (diff.inMinutes > 0) return 'ha ${diff.inMinutes} min';
    return 'agora';
  }
}
