import 'quiz_question.dart';

/// "Quiz da Semana" em destaque, carregado de `GET /quizzes/weekly`.
/// Só existe quando um Admin/Super Admin marca um quiz como semanal.
class WeeklyQuiz {
  const WeeklyQuiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;

  bool get hasQuestions => questions.isNotEmpty;

  factory WeeklyQuiz.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'];
    final questions = rawQuestions is List
        ? rawQuestions.whereType<Map<String, dynamic>>().map(_questionFromJson).toList()
        : <QuizQuestion>[];
    return WeeklyQuiz(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Quiz da Semana',
      description: json['description']?.toString() ?? '',
      questions: questions,
    );
  }

  static QuizQuestion _questionFromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final options = rawOptions is List ? rawOptions.whereType<Map<String, dynamic>>().toList() : <Map<String, dynamic>>[];
    // `isCorrect` só vem no quiz semanal; num quiz carregado por id fica oculto
    // (a correção acontece no servidor). `correctIndex` só é fiável quando vem.
    final correctIndex = options.indexWhere((o) => o['isCorrect'] == true);
    final optionIds = [for (final o in options) o['id']?.toString() ?? ''];
    final hasIds = json['id'] != null && optionIds.every((id) => id.isNotEmpty);
    return QuizQuestion(
      id: json['id']?.toString(),
      optionIds: hasIds ? optionIds : null,
      question: json['statement']?.toString() ?? '',
      options: [for (final o in options) o['text']?.toString() ?? ''],
      correctIndex: correctIndex < 0 ? 0 : correctIndex,
      explanation: json['explanation']?.toString() ?? '',
    );
  }
}
