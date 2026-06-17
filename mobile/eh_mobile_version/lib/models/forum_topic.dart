class ForumTopic {
  const ForumTopic({
    required this.title,
    required this.author,
    required this.comments,
    required this.tag,
    this.private = false,
    this.isPinned = false,
    this.authorRole = 'Estudante',
    this.timeAgo = 'há 1 dia',
    this.description = '',
    this.avatarUrl,
  });

  final String title;
  final String author;
  final int comments;
  final String tag;
  final bool private;
  final bool isPinned;
  final String authorRole;
  final String timeAgo;
  final String description;
  final String? avatarUrl;
}

