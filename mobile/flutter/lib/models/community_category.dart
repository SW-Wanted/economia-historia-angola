class CommunityCategory {
  const CommunityCategory({
    required this.name,
    required this.description,
    required this.topics,
    required this.members,
    this.private = false,
  });

  final String name;
  final String description;
  final int topics;
  final int members;
  final bool private;
}
