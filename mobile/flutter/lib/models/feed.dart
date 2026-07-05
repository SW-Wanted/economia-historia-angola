import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_illustration.dart';

/// Tipo de conteúdo apresentado no feed inteligente da Home.
///
/// Os textos são tratados como [article] — a partir de um artigo o autor ou
/// admin pode criar quizzes. Os [forum] são debates (livres ou de comunidade).
enum FeedContentType { article, video, podcast, quiz, jindungo, forum }

extension FeedContentTypeX on FeedContentType {
  String get label => switch (this) {
        FeedContentType.article => 'Artigo',
        FeedContentType.video => 'Vídeo',
        FeedContentType.podcast => 'Podcast',
        FeedContentType.quiz => 'Quiz',
        FeedContentType.jindungo => 'Jindungo',
        FeedContentType.forum => 'Fórum',
      };

  IconData get icon => switch (this) {
        FeedContentType.article => Icons.menu_book_outlined,
        FeedContentType.video => Icons.play_circle_outline,
        FeedContentType.podcast => Icons.mic_none_outlined,
        FeedContentType.quiz => Icons.quiz_outlined,
        FeedContentType.jindungo => Icons.local_fire_department_outlined,
        FeedContentType.forum => Icons.forum_outlined,
      };

  /// Verbo/ação apresentada no cartão consoante o tipo.
  String get action => switch (this) {
        FeedContentType.article => 'Ler artigo',
        FeedContentType.video => 'Assistir vídeo',
        FeedContentType.podcast => 'Ouvir áudio',
        FeedContentType.quiz => 'Responder quiz',
        FeedContentType.jindungo => 'Desbloquear',
        FeedContentType.forum => 'Ver debate',
      };

  /// Rota de destino ao abrir o conteúdo.
  String get route => switch (this) {
        FeedContentType.article => AppRoutes.reading,
        FeedContentType.video => AppRoutes.videoPlayer,
        FeedContentType.podcast => AppRoutes.podcastPlayer,
        FeedContentType.quiz => AppRoutes.quizHub,
        FeedContentType.jindungo => AppRoutes.restrictedContent,
        FeedContentType.forum => AppRoutes.forumTopic,
      };

  bool get isArticle => this == FeedContentType.article || this == FeedContentType.jindungo;
  bool get isForum => this == FeedContentType.forum;

  /// Conteúdo de aprendizagem do qual se pode gerar um quiz (artigo, vídeo ou
  /// podcast) — não se geram quizzes a partir de quizzes ou debates.
  bool get canGenerateQuiz =>
      this == FeedContentType.article ||
      this == FeedContentType.jindungo ||
      this == FeedContentType.video ||
      this == FeedContentType.podcast;
}

/// Motivo pelo qual um conteúdo foi recomendado. Alimenta o pequeno selo
/// "porquê" apresentado em cada cartão, aproximando a Home de um feed moderno.
enum FeedReason {
  recommendedCategory, // "Recomendado porque segue X"
  popularWeek, // "Popular esta semana"
  newContent, // "Novo artigo"
  basedOnReading, // "Baseado nas suas leituras"
  continueStudy, // "Ideal para continuar os seus estudos"
  trending, // "Em tendência"
  discover, // "Descubra uma nova área"
  community, // "Da sua comunidade eh/…"
}

extension FeedReasonX on FeedReason {
  IconData get icon => switch (this) {
        FeedReason.recommendedCategory => Icons.favorite_outline,
        FeedReason.popularWeek => Icons.local_fire_department_outlined,
        FeedReason.newContent => Icons.fiber_new_outlined,
        FeedReason.basedOnReading => Icons.auto_stories_outlined,
        FeedReason.continueStudy => Icons.school_outlined,
        FeedReason.trending => Icons.trending_up,
        FeedReason.discover => Icons.explore_outlined,
        FeedReason.community => Icons.groups_outlined,
      };

  Color get color => switch (this) {
        FeedReason.recommendedCategory => AppColors.primary,
        FeedReason.popularWeek => AppColors.warning,
        FeedReason.newContent => AppColors.success,
        FeedReason.basedOnReading => AppColors.navy,
        FeedReason.continueStudy => AppColors.tertiary,
        FeedReason.trending => AppColors.warning,
        FeedReason.discover => AppColors.navy,
        FeedReason.community => AppColors.navy,
      };

  /// Texto do selo. Alguns motivos incorporam o nome da categoria seguida.
  String label([String? category]) => switch (this) {
        FeedReason.recommendedCategory =>
          category == null ? 'Recomendado para si' : 'Porque segue $category',
        FeedReason.popularWeek => 'Popular esta semana',
        FeedReason.newContent => 'Novo',
        FeedReason.basedOnReading => 'Baseado nas suas leituras',
        FeedReason.continueStudy => 'Ideal para continuar os estudos',
        FeedReason.trending => 'Em tendência',
        FeedReason.discover => 'Descubra uma nova área',
        FeedReason.community => category == null ? 'Da sua comunidade' : 'Da sua comunidade $category',
      };
}

/// Um conteúdo do feed, já enriquecido com métricas de interação que permitem
/// ordenar por relevância/tendência sem depender de um algoritmo de ML.
class FeedContent {
  const FeedContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.type,
    required this.scene,
    required this.author,
    this.authorRole,
    required this.minutes,
    required this.publishedAt,
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.viewGrowth = 0,
    this.readProgress = 0,
    this.locked = false,
    this.community,
    this.communityPrivate = false,
    this.mediaUrl,
    this.sourceUrl,
    this.body,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final FeedContentType type;
  final EhScene scene;
  final String author;

  /// Cargo/função do autor (ex.: "Historiadora"), quando aplicável.
  final String? authorRole;
  final int minutes;

  /// Iniciais do autor para o avatar (o projeto usa avatares com iniciais).
  String get authorInitials {
    final parts = author.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final relevant = parts.where((p) => !p.endsWith('.')).toList();
    final use = relevant.isEmpty ? parts : relevant;
    if (use.length == 1) return use.first.substring(0, 1).toUpperCase();
    return (use.first[0] + use.last[0]).toUpperCase();
  }

  /// Data de publicação — usada para dar peso a conteúdos recentes.
  final DateTime publishedAt;

  final int views;
  final int likes;
  final int comments;
  final int shares;

  /// Crescimento recente das visualizações, em percentagem (0–100+). Distingue
  /// conteúdos que estão a "aquecer" agora dos que são apenas antigos e vistos.
  final int viewGrowth;

  /// Progresso de leitura (0–1). Alimenta a secção "Continue a ler".
  final double readProgress;

  /// Conteúdo Jindungo/premium — exige autorização/subscrição.
  final bool locked;

  /// Comunidade onde o conteúdo foi publicado (estilo Reddit `eh/…`), quando
  /// aplicável. `null` para conteúdo editorial geral.
  final String? community;

  /// A comunidade de origem é privada (acesso reservado a membros aprovados).
  final bool communityPrivate;

  /// URL do ficheiro de media (vídeo/áudio) carregado na criação — o que os
  /// players reproduzem. `null` para conteúdos sem media (ex.: artigos).
  final String? mediaUrl;

  /// Ligação de origem/fonte externa (ex.: URL de vídeo do YouTube colado na
  /// criação, ou referência bibliográfica de um artigo).
  final String? sourceUrl;

  /// Corpo/descrição completo do conteúdo, quando disponível — usado na leitura
  /// e como descrição nos players.
  final String? body;

  /// Endereço de reprodução: prioriza o ficheiro carregado, cai para a fonte.
  String? get playbackUrl => (mediaUrl != null && mediaUrl!.isNotEmpty)
      ? mediaUrl
      : (sourceUrl != null && sourceUrl!.isNotEmpty)
          ? sourceUrl
          : null;

  /// Identificador de comunidade estilo Reddit: `eh/HistóriaEconómica`.
  String? get communityHandle => community == null ? null : 'eh/${community!.replaceAll(' ', '')}';

  /// Qualquer conteúdo cujo acesso é reservado (Jindungo ou comunidade privada).
  bool get isRestricted => locked || communityPrivate;

  bool get isStarted => readProgress > 0 && readProgress < 1;
  int get percent => (readProgress * 100).round();

  /// Idade do conteúdo em dias, relativa a agora.
  int get ageInDays => DateTime.now().difference(publishedAt).inDays;

  bool get isNew => ageInDays <= 7;

  FeedContent copyWith({double? readProgress}) => FeedContent(
        id: id,
        title: title,
        subtitle: subtitle,
        category: category,
        type: type,
        scene: scene,
        author: author,
        authorRole: authorRole,
        minutes: minutes,
        publishedAt: publishedAt,
        views: views,
        likes: likes,
        comments: comments,
        shares: shares,
        viewGrowth: viewGrowth,
        readProgress: readProgress ?? this.readProgress,
        locked: locked,
        community: community,
        communityPrivate: communityPrivate,
        mediaUrl: mediaUrl,
        sourceUrl: sourceUrl,
        body: body,
      );
}

/// Uma entrada do feed: o conteúdo mais o motivo pelo qual foi recomendado.
class FeedEntry {
  const FeedEntry({required this.content, required this.reason, this.reasonCategory});

  final FeedContent content;
  final FeedReason reason;

  /// Categoria a incorporar no texto do motivo (ex.: "Porque segue X").
  final String? reasonCategory;

  String get reasonLabel => reason.label(reasonCategory);
}

/// Formata um número de interações de forma compacta (1240 -> "1,2 mil").
String formatCount(int value) {
  if (value < 1000) return '$value';
  final thousands = value / 1000;
  final text = thousands.toStringAsFixed(thousands >= 10 ? 0 : 1).replaceAll('.', ',');
  return '$text mil';
}

/// Rótulo relativo simples para a data de publicação.
String relativePublished(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inDays >= 365) return 'há ${diff.inDays ~/ 365} ano${diff.inDays ~/ 365 == 1 ? '' : 's'}';
  if (diff.inDays >= 30) return 'há ${diff.inDays ~/ 30} ${diff.inDays ~/ 30 == 1 ? 'mês' : 'meses'}';
  if (diff.inDays >= 1) return 'há ${diff.inDays} dia${diff.inDays == 1 ? '' : 's'}';
  if (diff.inHours >= 1) return 'há ${diff.inHours} h';
  if (diff.inMinutes >= 1) return 'há ${diff.inMinutes} min';
  return 'agora';
}
