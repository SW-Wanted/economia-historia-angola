class ForumTopic {
  const ForumTopic({
    required this.title,
    required this.author,
    required this.comments,
    required this.tag,
    this.private = false,
    this.role = 'Estudante',
    this.timeAgo = 'há 2 horas',
    this.excerpt = '',
    this.pinned = false,
  });

  final String title;
  final String author;
  final int comments;
  final String tag;
  final bool private;
  final String role;
  final String timeAgo;
  final String excerpt;
  final bool pinned;
}
