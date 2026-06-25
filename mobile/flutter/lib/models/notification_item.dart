import 'package:flutter/material.dart';

enum NotificationKind { quiz, forum, content, system, access }

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.kind,
    this.unread = false,
  });

  final String title;
  final String body;
  final String timeAgo;
  final NotificationKind kind;
  final bool unread;

  IconData get icon => switch (kind) {
        NotificationKind.quiz => Icons.quiz_outlined,
        NotificationKind.forum => Icons.forum_outlined,
        NotificationKind.content => Icons.menu_book_outlined,
        NotificationKind.system => Icons.info_outline,
        NotificationKind.access => Icons.lock_open_outlined,
      };
}
