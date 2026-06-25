import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/content_item.dart';
import '../models/content_report.dart';
import '../models/forum_topic.dart';
import '../models/notification_item.dart';
import '../models/ranking_user.dart';
import 'api_client.dart';
import 'mock_data_service.dart';

class BackendService {
  BackendService._();

  static final BackendService instance = BackendService._();

  final ApiClient _api = ApiClient();
  final MockDataService _fallback = const MockDataService();
  AppUser? _currentUser;

  bool get isAuthenticated => _api.isAuthenticated;

  /// Utilizador autenticado em cache; se não houver sessão, recorre aos
  /// dados mock (offline-first). Permite às telas síncronas mostrarem a
  /// identidade real após login sem reconstruções assíncronas.
  AppUser get cachedUser => _currentUser ?? _fallback.currentUser();

  Future<AppUser> login({required String email, required String password}) async {
    final json = await _api.postJson('/auth/login', {'email': email.trim(), 'password': password});
    _storeTokens(json);
    _currentUser = await _resolveProfile(json['user'] as Map<String, dynamic>?);
    return _currentUser!;
  }

  Future<AppUser> register({required String name, required String email, required String password}) async {
    final username = email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '').toLowerCase();
    final json = await _api.postJson('/auth/register', {
      'name': name.trim(),
      'email': email.trim(),
      'username': username.isEmpty ? 'utilizador' : username,
      'password': password,
    });
    _storeTokens(json);
    _currentUser = await _resolveProfile(json['user'] as Map<String, dynamic>?);
    return _currentUser!;
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
    if (!isAuthenticated) return _fallback.currentUser();
    if (_currentUser != null) return _currentUser!;
    try {
      final json = await _api.getJson('/users/me');
      _currentUser = _userFromProfile(json);
      return _currentUser!;
    } catch (_) {
      return _fallback.currentUser();
    }
  }

  Future<List<ContentItem>> contents({String? search}) async {
    try {
      final list = await _api.getList('/contents', query: {'search': search});
      final items = list.whereType<Map<String, dynamic>>().map(_contentFromJson).toList();
      return items.isEmpty ? _fallback.contents() : items;
    } catch (_) {
      return _fallback.contents();
    }
  }

  Future<List<ForumTopic>> forumTopics() async {
    try {
      final forums = await _api.getList('/forums');
      if (forums.isEmpty) return _fallback.topics();
      final forum = forums.first as Map<String, dynamic>;
      final topics = await _api.getList('/forums/${forum['id']}/topics');
      final items = topics.whereType<Map<String, dynamic>>().map(_topicFromJson).toList();
      return items.isEmpty ? _fallback.topics() : items;
    } catch (_) {
      return _fallback.topics();
    }
  }

  Future<List<RankingUser>> ranking() async {
    try {
      final list = await _api.getList('/quizzes/rankings');
      final items = list.whereType<Map<String, dynamic>>().map(_rankingFromJson).toList();
      return items.isEmpty ? _fallback.ranking() : items;
    } catch (_) {
      return _fallback.ranking();
    }
  }

  Future<List<NotificationItem>> notifications() async {
    if (!isAuthenticated) return _fallback.notifications();
    try {
      final list = await _api.getList('/notifications');
      final items = list.whereType<Map<String, dynamic>>().map(_notificationFromJson).toList();
      return items.isEmpty ? _fallback.notifications() : items;
    } catch (_) {
      return _fallback.notifications();
    }
  }

  Future<List<ContentReport>> reports() async {
    if (!isAuthenticated) return _fallback.reports();
    try {
      final list = await _api.getList('/reports');
      final items = list.whereType<Map<String, dynamic>>().map(_reportFromJson).toList();
      return items.isEmpty ? _fallback.reports() : items;
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
  }

  void _storeTokens(Map<String, dynamic> json) {
    _api.accessToken = json['accessToken']?.toString();
    _api.refreshToken = json['refreshToken']?.toString();
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
    return AppUser(
      name: name,
      initials: _initials(name),
      role: _roleFromBackend((json['roles'] as List?)?.map((item) {
        if (item is Map && item['role'] is Map) return item['role']['code'];
        return item;
      }).toList()),
      course: json['school']?.toString() ?? 'Economia',
      email: json['email']?.toString() ?? '',
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
      author: json['authorName']?.toString() ?? 'Economia com Historia',
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
    return RankingUser(
      name: name,
      points: score,
      level: score >= 900 ? 'Mestre Jindungo' : score >= 500 ? 'Analista' : 'Explorador',
      initials: _initials(name),
    );
  }

  NotificationItem _notificationFromJson(Map<String, dynamic> json) {
    return NotificationItem(
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
    if (value.contains('audio')) return Icons.headphones_outlined;
    return Icons.menu_book_outlined;
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
