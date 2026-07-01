import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_illustration.dart';

/// Tipo de conteúdo apresentado no feed inteligente da Home.
enum FeedContentType { article, podcast, quiz, jindungo }

extension FeedContentTypeX on FeedContentType {
  String get label => switch (this) {
        FeedContentType.article => 'Artigo',
        FeedContentType.podcast => 'Podcast',
        FeedContentType.quiz => 'Quiz',
        FeedContentType.jindungo => 'Jindungo',
      };

  IconData get icon => switch (this) {
        FeedContentType.article => Icons.menu_book_outlined,
        FeedContentType.podcast => Icons.headphones_outlined,
        FeedContentType.quiz => Icons.quiz_outlined,
        FeedContentType.jindungo => Icons.local_fire_department_outlined,
      };

  /// Verbo/ação apresentada no cartão consoante o tipo.
  String get action => switch (this) {
        FeedContentType.article => 'Ler artigo',
        FeedContentType.podcast => 'Ouvir',
        FeedContentType.quiz => 'Responder',
        FeedContentType.jindungo => 'Desbloquear',
      };

  /// Rota de destino ao abrir o conteúdo.
  String get route => switch (this) {
        FeedContentType.article => AppRoutes.reading,
        FeedContentType.podcast => AppRoutes.podcastPlayer,
        FeedContentType.quiz => AppRoutes.quizHub,
        FeedContentType.jindungo => AppRoutes.restrictedContent,
      };
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
      };

  Color get color => switch (this) {
        FeedReason.recommendedCategory => AppColors.primary,
        FeedReason.popularWeek => AppColors.warning,
        FeedReason.newContent => AppColors.success,
        FeedReason.basedOnReading => AppColors.navy,
        FeedReason.continueStudy => AppColors.tertiary,
        FeedReason.trending => AppColors.warning,
        FeedReason.discover => AppColors.navy,
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
    required this.minutes,
    required this.publishedAt,
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.viewGrowth = 0,
    this.readProgress = 0,
    this.locked = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final FeedContentType type;
  final EhScene scene;
  final String author;
  final int minutes;

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

  final bool locked;

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
        minutes: minutes,
        publishedAt: publishedAt,
        views: views,
        likes: likes,
        comments: comments,
        shares: shares,
        viewGrowth: viewGrowth,
        readProgress: readProgress ?? this.readProgress,
        locked: locked,
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
