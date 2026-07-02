class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.id,
    this.optionIds,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  /// Id da pergunta no backend. `null` para perguntas locais (geradas/mock).
  final String? id;

  /// Ids das opções, na mesma ordem de [options]. `null` para perguntas locais.
  final List<String>? optionIds;

  /// Verdadeiro quando a pergunta pode ser resolvida no servidor (tem ids).
  bool get hasBackendIds => id != null && optionIds != null && optionIds!.length == options.length;
}
