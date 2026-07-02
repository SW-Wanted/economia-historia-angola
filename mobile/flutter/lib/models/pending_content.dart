class PendingContent {
  const PendingContent({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.excerpt,
    required this.timeAgo,
  });

  final String id;
  final String title;
  final String author;
  final String type;
  final String excerpt;
  final String timeAgo;
}
