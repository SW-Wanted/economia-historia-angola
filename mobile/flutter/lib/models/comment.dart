class Comment {
  const Comment({
    required this.author,
    required this.initials,
    required this.text,
    required this.timeAgo,
    this.role,
    this.likes = 0,
    this.isAuthor = false,
  });

  final String author;
  final String initials;
  final String text;
  final String timeAgo;
  final String? role;
  final int likes;
  final bool isAuthor;
}
