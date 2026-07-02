/// Estado de adesão do utilizador atual a uma comunidade.
enum CommunityViewerStatus { none, pending, active }

CommunityViewerStatus communityViewerStatusFrom(Object? raw) {
  switch (raw?.toString().toUpperCase()) {
    case 'ACTIVE':
      return CommunityViewerStatus.active;
    case 'PENDING':
      return CommunityViewerStatus.pending;
    default:
      return CommunityViewerStatus.none;
  }
}

class CommunityCategory {
  const CommunityCategory({
    required this.name,
    required this.description,
    required this.topics,
    required this.members,
    this.private = false,
    this.id,
    this.viewerStatus = CommunityViewerStatus.none,
  });

  /// Identificador da comunidade no backend. `null` para categorias mock/locais.
  final String? id;
  final String name;
  final String description;
  final int topics;
  final int members;
  final bool private;
  final CommunityViewerStatus viewerStatus;

  bool get isMember => viewerStatus == CommunityViewerStatus.active;
  bool get isPending => viewerStatus == CommunityViewerStatus.pending;

  CommunityCategory copyWith({
    int? topics,
    int? members,
    CommunityViewerStatus? viewerStatus,
  }) {
    return CommunityCategory(
      id: id,
      name: name,
      description: description,
      topics: topics ?? this.topics,
      members: members ?? this.members,
      private: private,
      viewerStatus: viewerStatus ?? this.viewerStatus,
    );
  }
}
