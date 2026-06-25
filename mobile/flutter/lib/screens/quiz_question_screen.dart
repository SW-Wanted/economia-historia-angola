import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/quiz_question.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  late final List<QuizQuestion> _questions = const MockDataService().questions();
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;

  QuizQuestion get _q => _questions[_index];
  bool get _isLast => _index == _questions.length - 1;

  void _confirm() {
    if (_selected == null) return;
    setState(() {
      _answered = true;
      if (_selected == _q.correctIndex) _score++;
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.quizResult,
        arguments: {'score': _score, 'total': _questions.length},
      );
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _answered = false;
    });
  }

  Color _optionColor(int i) {
    if (!_answered) return _selected == i ? AppColors.surfaceContainer : AppColors.surface;
    if (i == _q.correctIndex) return AppColors.success.withValues(alpha: .14);
    if (i == _selected) return AppColors.error.withValues(alpha: .12);
    return AppColors.surface;
  }

  Color _avatarColor(int i) {
    if (!_answered) return _selected == i ? AppColors.primary : AppColors.surfaceHighest;
    if (i == _q.correctIndex) return AppColors.success;
    if (i == _selected) return AppColors.error;
    return AppColors.surfaceHighest;
  }

  @override
  Widget build(BuildContext context) {
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
                foregroundColor: (_selected == i || (_answered && i == _q.correctIndex)) ? Colors.white : AppColors.primary,
                child: _answered && i == _q.correctIndex
                    ? const Icon(Icons.check, size: 20)
                    : (_answered && i == _selected ? const Icon(Icons.close, size: 20) : Text(String.fromCharCode(65 + i))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(_q.options[i])),
            ]),
          ),
          const SizedBox(height: 10),
        ],

        // Feedback formativo
        if (_answered) ...[
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
          label: !_answered ? 'Confirmar' : (_isLast ? 'Ver resultado' : 'Próxima pergunta'),
          onPressed: !_answered ? (_selected == null ? null : _confirm) : _next,
        ),
      ],
    );
  }
}
