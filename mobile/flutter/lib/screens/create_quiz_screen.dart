import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../models/quiz_question.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../services/quiz_generator.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Criação de um quiz a partir de um conteúdo (artigo, vídeo ou podcast).
///
/// Suporta duas vias: geração automática por um **assistente de IA** (simulado
/// em [QuizGenerator]) e criação/edição manual. As perguntas geradas ficam
/// editáveis antes de publicar.
class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key, this.content, this.editQuizId});

  final FeedContent? content;

  /// Quando fornecido, o ecrã entra em **modo de edição**: carrega o quiz,
  /// pré-preenche as perguntas e publica via PATCH em vez de criar.
  final String? editQuizId;

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  int _count = 5;
  String _difficulty = 'Médio';
  bool _generating = false;
  bool _publishing = false;
  bool _loadingExisting = false;
  String _editTitle = 'Novo quiz';
  final List<_QuestionDraft> _drafts = [];

  bool get _isEdit => widget.editQuizId != null;
  String get _title => _isEdit ? _editTitle : (widget.content?.title ?? 'Novo quiz');
  String get _category => widget.content?.category ?? 'Economia';

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    setState(() => _loadingExisting = true);
    try {
      final quiz = await BackendService.instance.quizForEdit(widget.editQuizId!);
      if (!mounted) return;
      setState(() {
        _editTitle = quiz.title;
        _drafts
          ..clear()
          ..addAll(quiz.questions.map(_QuestionDraft.from));
        _loadingExisting = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingExisting = false);
      _snack(error.toString());
    }
  }

  @override
  void dispose() {
    for (final d in _drafts) {
      d.dispose();
    }
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() => _generating = true);
    List<QuizQuestion> questions;
    var usedFallback = false;
    try {
      // IA real (Gemini) no backend, a partir do tema/categoria do conteúdo.
      questions = await BackendService.instance.generateQuizQuestions(
        title: _title,
        category: _category,
        context: widget.content?.subtitle,
        count: _count,
        difficulty: _difficulty,
      );
      if (questions.isEmpty) throw Exception('Sem perguntas geradas.');
    } catch (_) {
      // Fallback: gerador local para não bloquear a criação se a IA falhar.
      usedFallback = true;
      questions = await QuizGenerator.instance.generate(
        title: _title,
        category: _category,
        count: _count,
        difficulty: _difficulty,
      );
    }
    if (!mounted) return;
    setState(() {
      for (final d in _drafts) {
        d.dispose();
      }
      _drafts
        ..clear()
        ..addAll(questions.map(_QuestionDraft.from));
      _generating = false;
    });
    if (usedFallback) {
      _snack('IA indisponível — geradas perguntas de exemplo. Reveja antes de publicar.');
    }
  }

  void _addManual() => setState(() => _drafts.add(_QuestionDraft.blank()));

  void _remove(int i) => setState(() => _drafts.removeAt(i).dispose());

  Future<void> _publish() async {
    if (_drafts.isEmpty) {
      _snack('Adicione ou gere pelo menos uma pergunta.');
      return;
    }
    for (final d in _drafts) {
      if (!d.isValid) {
        _snack('Preencha a pergunta, pelo menos duas opções e marque a correta.');
        return;
      }
    }
    setState(() => _publishing = true);
    try {
      final questions = _drafts.map((draft) => draft.toJson()).toList();
      if (_isEdit) {
        await BackendService.instance.updateQuiz(
          id: widget.editQuizId!,
          questions: questions,
        );
      } else {
        await BackendService.instance.createQuiz(
          title: _title,
          description: 'Quiz sobre $_category.',
          questions: questions,
        );
      }
      await FeedService.instance.load(force: true);
      if (!mounted) return;
      if (_isEdit) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz atualizado com sucesso.'), behavior: SnackBarBehavior.floating),
        );
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.publishConfirmation);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _publishing = false);
      _snack(error.toString());
    }
  }

  void _snack(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: _isEdit ? 'Editar Quiz' : 'Criar Quiz',
      showBack: true,
      children: [
        _sourceCard(context),
        const SizedBox(height: 22),
        if (_loadingExisting)
          _loading(context)
        else if (_generating)
          _loading(context)
        else if (_drafts.isEmpty)
          _aiPanel(context)
        else
          ..._editor(context),
      ],
    );
  }

  // ------------------------------------------------------ Conteúdo de origem

  Widget _sourceCard(BuildContext context) {
    final type = widget.content?.type;
    return EhCard(
      color: AppColors.surfaceLow,
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
          child: Icon(type?.icon ?? Icons.menu_book_outlined, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('A partir de ${type?.label.toLowerCase() ?? 'conteúdo'}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            const SizedBox(height: 2),
            Text(_title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
            Text(_category, style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }

  // ------------------------------------------------------------- Painel IA

  Widget _aiPanel(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Cartão do assistente.
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Assistente de IA', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
          ]),
          const SizedBox(height: 8),
          Text('Gere automaticamente perguntas a partir deste conteúdo. Pode rever e editar tudo antes de publicar.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .9), height: 1.4)),
        ]),
      ),
      const SizedBox(height: 20),
      const SectionTitle('Número de perguntas'),
      const SizedBox(height: 10),
      Row(children: [
        for (final n in [3, 5, 10]) ...[
          _choice('$n', _count == n, () => setState(() => _count = n)),
          const SizedBox(width: 10),
        ],
      ]),
      const SizedBox(height: 18),
      const SectionTitle('Dificuldade'),
      const SizedBox(height: 10),
      Row(children: [
        for (final d in ['Fácil', 'Médio', 'Difícil']) ...[
          _choice(d, _difficulty == d, () => setState(() => _difficulty = d)),
          const SizedBox(width: 10),
        ],
      ]),
      const SizedBox(height: 24),
      EhButton(label: 'Gerar com IA', icon: Icons.auto_awesome, onPressed: _generate),
      const SizedBox(height: 12),
      Row(children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('ou', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ),
        const Expanded(child: Divider()),
      ]),
      const SizedBox(height: 12),
      EhButton(label: 'Criar manualmente', secondary: true, icon: Icons.edit_outlined, onPressed: _addManual),
    ]);
  }

  Widget _choice(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: .6)),
            ),
            child: Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : AppColors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5)),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------- A gerar…

  Widget _loading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(children: [
        const AppLoadingIndicator(size: 96, showDots: false),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text('O assistente está a gerar perguntas…',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
        ]),
        const SizedBox(height: 6),
        Text('A analisar "$_title"', textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]),
    );
  }

  // -------------------------------------------------------------- Editor

  List<Widget> _editor(BuildContext context) {
    return [
      Row(children: [
        Expanded(child: SectionTitle('Perguntas (${_drafts.length})')),
        TextButton.icon(
          onPressed: _generate,
          icon: const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
          label: const Text('Regenerar', style: TextStyle(color: AppColors.primary)),
        ),
      ]),
      const SizedBox(height: 8),
      for (var i = 0; i < _drafts.length; i++) ...[
        _questionCard(context, i),
        const SizedBox(height: 14),
      ],
      EhButton(label: 'Adicionar pergunta', secondary: true, icon: Icons.add, onPressed: _addManual),
      const SizedBox(height: 20),
      EhButton(label: _publishing ? 'A publicar...' : 'Publicar quiz', icon: Icons.check_rounded, onPressed: _publishing ? null : _publish),
      const SizedBox(height: 8),
    ];
  }

  Widget _questionCard(BuildContext context, int index) {
    final d = _drafts[index];
    return EhCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Pergunta ${index + 1}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14, color: AppColors.primary)),
          const Spacer(),
          IconButton(
            onPressed: () => _remove(index),
            icon: const Icon(Icons.delete_outline, color: AppColors.secondary),
            tooltip: 'Remover',
          ),
        ]),
        TextField(
          controller: d.question,
          minLines: 1, maxLines: 3,
          decoration: const InputDecoration(hintText: 'Escreva a pergunta'),
        ),
        const SizedBox(height: 12),
        Text('Opções · marque a correta',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 6),
        RadioGroup<int>(
          groupValue: d.correctIndex,
          onChanged: (v) => setState(() => d.correctIndex = v ?? 0),
          child: Column(
            children: [
              for (var o = 0; o < d.options.length; o++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Radio<int>(value: o, activeColor: AppColors.primary),
                    Expanded(
                      child: TextField(
                        controller: d.options[o],
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Opção ${o + 1}',
                        ),
                      ),
                    ),
                  ]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: d.explanation,
          minLines: 1, maxLines: 3,
          decoration: const InputDecoration(hintText: 'Explicação (opcional)'),
        ),
      ]),
    );
  }
}

/// Rascunho editável de uma pergunta, com os seus controladores de texto.
class _QuestionDraft {
  _QuestionDraft.blank();

  factory _QuestionDraft.from(QuizQuestion q) {
    final d = _QuestionDraft.blank();
    d.question.text = q.question;
    for (var i = 0; i < d.options.length; i++) {
      d.options[i].text = i < q.options.length ? q.options[i] : '';
    }
    d.explanation.text = q.explanation;
    d.correctIndex = q.correctIndex.clamp(0, d.options.length - 1);
    return d;
  }

  final TextEditingController question = TextEditingController();
  final List<TextEditingController> options = List.generate(4, (_) => TextEditingController());
  final TextEditingController explanation = TextEditingController();
  int correctIndex = 0;

  bool get isValid {
    if (question.text.trim().isEmpty) return false;
    final filled = options.where((o) => o.text.trim().isNotEmpty).length;
    if (filled < 2) return false;
    return options[correctIndex].text.trim().isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    final filledOptions = <Map<String, dynamic>>[];
    for (var i = 0; i < options.length; i++) {
      final text = options[i].text.trim();
      if (text.isEmpty) continue;
      filledOptions.add({
        'text': text,
        'isCorrect': i == correctIndex,
      });
    }
    return {
      'statement': question.text.trim(),
      'explanation': explanation.text.trim(),
      'points': 1,
      'options': filledOptions,
    };
  }

  void dispose() {
    question.dispose();
    for (final o in options) {
      o.dispose();
    }
    explanation.dispose();
  }
}
