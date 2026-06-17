class ForumTopic {
  const ForumTopic({
    required this.title,
    required this.author,
    required this.comments,
    required this.tag,
    this.private = false,
  });

  final String title;
  final String author;
  final int comments;
  final String tag;
  final bool private;
}
