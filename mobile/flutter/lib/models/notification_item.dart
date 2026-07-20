import 'package:flutter/material.dart';

enum NotificationKind { quiz, forum, content, community, comment, system, access }

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.kind,
    this.unread = false,
    this.id,
    this.data = const {},
  });

  /// Identificador no backend. `null` para itens sem persistência (ex.: erro).
  final String? id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationKind kind;
  final bool unread;

  /// Payload da notificação (ex.: `roomId`, `communityId`, `contentId`) usado
  /// para navegar diretamente para o recurso correspondente ao tocar.
  final Map<String, dynamic> data;

  String? get roomId => data['roomId']?.toString();
  String? get communityId => data['communityId']?.toString();
  String? get contentId => data['contentId']?.toString();

  NotificationItem copyWith({bool? unread}) => NotificationItem(
        id: id,
        title: title,
        body: body,
        timeAgo: timeAgo,
        kind: kind,
        unread: unread ?? this.unread,
        data: data,
      );

  IconData get icon => switch (kind) {
        NotificationKind.quiz => Icons.quiz_outlined,
        NotificationKind.forum => Icons.forum_outlined,
        NotificationKind.content => Icons.menu_book_outlined,
        NotificationKind.community => Icons.groups_outlined,
        NotificationKind.comment => Icons.mode_comment_outlined,
        NotificationKind.system => Icons.info_outline,
        NotificationKind.access => Icons.lock_open_outlined,
      };
}
