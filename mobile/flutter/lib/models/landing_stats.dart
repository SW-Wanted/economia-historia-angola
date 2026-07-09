/// Contagens públicas da landing (secção "A comunidade em números").
/// Alimentadas pelo endpoint público `GET /stats/landing` do backend.
class LandingStats {
  const LandingStats({
    required this.members,
    required this.contents,
    required this.quizzes,
  });

  final int members;
  final int contents;
  final int quizzes;
}
