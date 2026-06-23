import 'package:flutter/material.dart';

/// Motivo de uma denuncia (alinhado com ReportScreen).
enum ReportReason { offensive, misinformation, spam, partisan, other }

extension ReportReasonX on ReportReason {
  String get label => switch (this) {
        ReportReason.offensive => 'Conteudo ofensivo ou de odio',
        ReportReason.misinformation => 'Informacao falsa ou enganosa',
        ReportReason.spam => 'Spam ou publicidade',
        ReportReason.partisan => 'Conteudo partidario',
        ReportReason.other => 'Outro motivo',
      };
}

/// Tipo de conteudo denunciado.
enum ReportTarget { content, comment, topic }

extension ReportTargetX on ReportTarget {
  String get label => switch (this) {
        ReportTarget.content => 'Conteudo',
        ReportTarget.comment => 'Comentario',
        ReportTarget.topic => 'Topico',
      };

  IconData get icon => switch (this) {
        ReportTarget.content => Icons.menu_book_outlined,
        ReportTarget.comment => Icons.chat_bubble_outline,
        ReportTarget.topic => Icons.forum_outlined,
      };
}

/// Uma denuncia pendente de revisao pela moderacao.
class ContentReport {
  const ContentReport({
    required this.title,
    required this.target,
    required this.reason,
    required this.excerpt,
    required this.timeAgo,
    this.count = 1,
  });

  final String title;
  final ReportTarget target;
  final ReportReason reason;
  final String excerpt;
  final String timeAgo;

  /// Numero de utilizadores que denunciaram o mesmo conteudo.
  final int count;
}
