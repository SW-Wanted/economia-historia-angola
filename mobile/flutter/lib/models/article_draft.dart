/// Dados de um conteúdo acabado de criar, passados ao ecrã de leitura para que
/// este **espelhe** exatamente o que foi introduzido no momento da criação.
class ArticleDraft {
  const ArticleDraft({
    required this.title,
    required this.typeLabel,
    required this.category,
    required this.body,
    this.source = '',
    this.community,
    this.minutes = 5,
    this.jindungo = false,
    this.exclusive = false,
    this.privateRoom = false,
  });

  final String title;
  final String typeLabel; // Artigo / Vídeo / Podcast / …
  final String category;
  final String body;
  final String source;
  final String? community;
  final int minutes;
  final bool jindungo;
  final bool exclusive;

  /// Sala de discussão privada (turma) — o dono é o professor.
  final bool privateRoom;
}
