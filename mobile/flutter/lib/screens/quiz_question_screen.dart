import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/quiz_question.dart';
import '../models/weekly_quiz.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key, this.quiz, this.quizId});

  /// Quiz já carregado (passado a partir do cartão "Quiz da Semana"). Quando
  /// `null`, o ecrã carrega o quiz semanal do backend.
  final WeeklyQuiz? quiz;
  final String? quizId;

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  late final Future<WeeklyQuiz?> _quizF = widget.quiz != null
      ? Future.value(widget.quiz)
      : widget.quizId != null
          ? BackendService.instance.quizById(widget.quizId!)
          : BackendService.instance.weeklyQuiz();

  List<QuizQuestion> _questions = const [];
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;

  // Resolução no servidor: quando o quiz tem id de backend, a correção e a
  // pontuação são feitas pelo servidor (start/answer/submit). Nesse modo não
  // mostramos "certo/errado" por pergunta — o servidor não revela `isCorrect`.
  String? _attemptId;
  bool _submitting = false;

  bool get _serverScored => _attemptId != null && _q.hasBackendIds;
  QuizQuestion get _q => _questions[_index];
  bool get _isLast => _index == _questions.length - 1;

  /// Arranca uma tentativa no servidor quando o quiz é de backend e as
  /// perguntas trazem ids. Falha silenciosa → cai para pontuação local.
  Future<void> _maybeStartAttempt(WeeklyQuiz quiz) async {
    if (_attemptId != null) return;
    if (quiz.id.isEmpty || !quiz.questions.every((q) => q.hasBackendIds)) return;
    try {
      final attemptId = await BackendService.instance.startQuizAttempt(quiz.id);
      if (mounted) setState(() => _attemptId = attemptId);
    } catch (_) {
      // Sem tentativa no servidor: mantém a resolução local.
    }
  }

  Future<void> _confirm() async {
    if (_selected == null) return;
    setState(() => _answered = true);
    if (_serverScored) {
      // Regista a resposta no servidor (a nota final vem do submit).
      try {
        await BackendService.instance.answerQuizQuestion(
          attemptId: _attemptId!,
          questionId: _q.id!,
          optionId: _q.optionIds![_selected!],
        );
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } else if (_selected == _q.correctIndex) {
      setState(() => _score++);
    }
  }

  Future<void> _next() async {
    if (_isLast) {
      await _finish();
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _answered = false;
    });
  }

  Future<void> _finish() async {
    int score = _score;
    if (_attemptId != null) {
      setState(() => _submitting = true);
      try {
        score = await BackendService.instance.submitQuizAttempt(_attemptId!);
      } catch (_) {
        score = _score; // fallback à contagem local
      }
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.quizResult,
      arguments: {'score': score, 'total': _questions.length},
    );
  }

  Color _optionColor(int i) {
    if (!_answered) return _selected == i ? AppColors.surfaceContainer : AppColors.surface;
    // No modo servidor não revelamos a opção correta — apenas destacamos a escolha.
    if (_serverScored) return i == _selected ? AppColors.surfaceContainer : AppColors.surface;
    if (i == _q.correctIndex) return AppColors.success.withValues(alpha: .14);
    if (i == _selected) return AppColors.error.withValues(alpha: .12);
    return AppColors.surface;
  }

  Color _avatarColor(int i) {
    if (!_answered) return _selected == i ? AppColors.primary : AppColors.surfaceHighest;
    if (_serverScored) return i == _selected ? AppColors.primary : AppColors.surfaceHighest;
    if (i == _q.correctIndex) return AppColors.success;
    if (i == _selected) return AppColors.error;
    return AppColors.surfaceHighest;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeeklyQuiz?>(
      future: _quizF,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const ScreenFrame(
            title: 'Quiz da Semana',
            showBack: true,
            children: [
              Padding(padding: EdgeInsets.only(top: 60), child: Center(child: AppLoadingIndicator(message: 'A carregar quiz...'))),
            ],
          );
        }
        final quiz = snapshot.data;
        if (quiz == null || !quiz.hasQuestions) {
          return ScreenFrame(
            title: 'Quiz da Semana',
            showBack: true,
            children: [_noQuiz(context)],
          );
        }
        // Preenche as perguntas uma única vez a partir do quiz carregado e
        // arranca a tentativa no servidor (após o frame, para não fazer
        // setState durante o build).
        if (_questions.isEmpty) {
          _questions = quiz.questions;
          WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartAttempt(quiz));
        }
        return _quizContent(context);
      },
    );
  }

  Widget _noQuiz(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Center(
          child: Column(children: [
            const Icon(Icons.quiz_outlined, size: 44, color: AppColors.outline),
            const SizedBox(height: 12),
            Text('Sem quiz da semana',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Ainda não há um Quiz da Semana disponível. Volte mais tarde.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ]),
        ),
      );

  Widget _quizContent(BuildContext context) {
    final progress = (_index + 1) / _questions.length;
    return ScreenFrame(
      title: 'Pergunta ${_index + 1}/${_questions.length}',
      showBack: true,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress, minHeight: 8,
                  color: AppColors.primary, backgroundColor: AppColors.outlineVariant),
              ),
            ),
            const SizedBox(width: 12),
            // No modo servidor a pontuação só é conhecida no fim (submit).
            if (!_serverScored)
              Text('Pontos: $_score', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 24),
        Text(_q.question, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        for (var i = 0; i < _q.options.length; i++) ...[
          EhCard(
            color: _optionColor(i),
            onTap: _answered ? null : () => setState(() => _selected = i),
            child: Row(children: [
              CircleAvatar(
                backgroundColor: _avatarColor(i),
                foregroundColor: (_selected == i || (_answered && !_serverScored && i == _q.correctIndex)) ? Colors.white : AppColors.primary,
                child: _answered && !_serverScored && i == _q.correctIndex
                    ? const Icon(Icons.check, size: 20)
                    : (_answered && !_serverScored && i == _selected ? const Icon(Icons.close, size: 20) : Text(String.fromCharCode(65 + i))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(_q.options[i])),
            ]),
          ),
          const SizedBox(height: 10),
        ],

        // Feedback formativo. No modo servidor não revelamos certo/errado por
        // pergunta — mostramos apenas confirmação (a nota final vem do submit).
        if (_answered && _serverScored) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Resposta registada. Verá o resultado no final.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
                ),
              ],
            ),
          ),
        ] else if (_answered) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (_selected == _q.correctIndex ? AppColors.success : AppColors.primary).withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_selected == _q.correctIndex ? Icons.check_circle : Icons.lightbulb_outline,
                    color: _selected == _q.correctIndex ? AppColors.success : AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selected == _q.correctIndex ? 'Correto!' : 'Não foi desta',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(_q.explanation, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        EhButton(
          label: _submitting
              ? 'A submeter...'
              : (!_answered ? 'Confirmar' : (_isLast ? 'Ver resultado' : 'Próxima pergunta')),
          onPressed: _submitting
              ? null
              : (!_answered ? (_selected == null ? null : _confirm) : _next),
        ),
      ],
    );
  }
}
