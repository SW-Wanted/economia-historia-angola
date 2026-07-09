/// Estatísticas agregadas do perfil ("O Meu Progresso").
/// Alimentadas pelo endpoint `GET /users/me/stats` do backend.
class ProfileStats {
  const ProfileStats({
    required this.points,
    required this.rank,
    required this.contentsCompleted,
    required this.quizzesTaken,
  });

  final int points;

  /// Posição global no ranking; `null` se o utilizador ainda não pontuou.
  final int? rank;
  final int contentsCompleted;
  final int quizzesTaken;

  factory ProfileStats.fromJson(Map<String, dynamic> json) => ProfileStats(
        points: int.tryParse(json['points']?.toString() ?? '') ?? 0,
        rank: json['rank'] == null ? null : int.tryParse(json['rank'].toString()),
        contentsCompleted: int.tryParse(json['contentsCompleted']?.toString() ?? '') ?? 0,
        quizzesTaken: int.tryParse(json['quizzesTaken']?.toString() ?? '') ?? 0,
      );
}
