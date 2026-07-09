/// Sala privada de discussão (estilo sala de estudo liderada por um professor).
class DiscussionRoom {
  const DiscussionRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.isOwner,
    required this.participants,
    required this.messages,
  });

  final String id;
  final String name;
  final String description;

  /// Verdadeiro quando o utilizador atual é o professor/dono da sala.
  final bool isOwner;
  final int participants;
  final int messages;

  factory DiscussionRoom.fromJson(Map<String, dynamic> json) {
    final count = json['_count'];
    return DiscussionRoom(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sala privada',
      description: json['description']?.toString() ?? '',
      isOwner: json['isOwner'] == true,
      participants: count is Map ? int.tryParse(count['participants']?.toString() ?? '') ?? 0 : 0,
      messages: count is Map ? int.tryParse(count['comments']?.toString() ?? '') ?? 0 : 0,
    );
  }
}

/// Participante de uma sala.
class RoomParticipant {
  const RoomParticipant({required this.userId, required this.name, this.avatarUrl});

  final String userId;
  final String name;
  final String? avatarUrl;

  factory RoomParticipant.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return RoomParticipant(
      userId: json['userId']?.toString() ?? (user is Map ? user['id']?.toString() ?? '' : ''),
      name: user is Map ? (user['name']?.toString() ?? 'Participante') : 'Participante',
      avatarUrl: user is Map ? user['avatarUrl']?.toString() : null,
    );
  }
}

/// Mensagem (comentário) de uma sala.
class RoomMessage {
  const RoomMessage({required this.author, required this.text, required this.authorId});

  final String authorId;
  final String author;
  final String text;

  factory RoomMessage.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return RoomMessage(
      authorId: author is Map ? (author['id']?.toString() ?? '') : '',
      author: author is Map ? (author['name']?.toString() ?? 'Participante') : 'Participante',
      text: json['text']?.toString() ?? '',
    );
  }
}
