import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../models/weekly_quiz.dart';
import '../services/backend_service.dart';
import '../services/feed_interactions.dart';
import '../services/feed_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Quizzes — segue o mesmo padrão das restantes páginas (ScreenFrame, cabeçalho
/// harmonizado, filtros e cartões). Mostra os quizzes **pendentes** ligados aos
/// conteúdos que o utilizador viu e os quizzes já **concluídos**.
class QuizHubScreen extends StatefulWidget {
  const QuizHubScreen({super.key});

  @override
  State<QuizHubScreen> createState() => _QuizHubScreenState();
}

class _QuizHubScreenState extends State<QuizHubScreen> {
  int _filter = 0;
  static const _filters = ['Pendentes', 'Concluídos'];

  late final Future<void> _catalogF = FeedService.instance.load();
  late final Future<WeeklyQuiz?> _weeklyF = BackendService.instance.weeklyQuiz();

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Quizzes',
      showBack: true,
      showNotifications: false,
      children: [
        // O destaque "Quiz da Semana" só aparece quando existe um quiz semanal.
        FutureBuilder<WeeklyQuiz?>(
          future: _weeklyF,
          builder: (context, snapshot) {
            final quiz = snapshot.data;
            if (quiz == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _weeklyHero(context, quiz),
            );
          },
        ),
        FilterChipsRow(labels: _filters, selected: _filter, onSelected: (i) => setState(() => _filter = i)),
        const SizedBox(height: 8),
        SectionTitle(_filter == 0 ? 'Pendentes para si' : 'Concluídos'),
        const SizedBox(height: 12),
        FutureBuilder<void>(
          future: _catalogF,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: AppLoadingIndicator(size: 72, showDots: false, message: 'A carregar quizzes...')),
              );
            }
            final fs = FeedService.instance;
            final store = FeedInteractions.instance;
            final quizzes = fs.catalog.where((c) => c.type == FeedContentType.quiz).toList();

            // Categorias dos conteúdos que o utilizador viu (+ leituras/favoritas).
            final viewedCats = fs.catalog.where((c) => store.isViewed(c.id)).map((c) => c.category).toSet();
            final interestCats = {...viewedCats, ...fs.readingHistory, ...fs.favoriteCategories};

            final pending = quizzes
                .where((q) => !store.isQuizCompleted(q.id) && (interestCats.isEmpty || interestCats.contains(q.category)))
                .toList();
            final completed = quizzes.where((q) => store.isQuizCompleted(q.id)).toList();
            final list = _filter == 0 ? pending : completed;

            if (list.isEmpty) return _empty(context);
            return Column(
              children: [
                for (final q in list) _quizCard(context, q, completed: _filter == 1, score: store.quizScore(q.id)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _weeklyHero(BuildContext context, WeeklyQuiz quiz) {
    const gold = AppColors.warning;
    return EhCard(
      color: AppColors.primary,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: gold.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: gold.withValues(alpha: .45)),
            ),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.emoji_objects_outlined, color: gold, size: 15),
              SizedBox(width: 6),
              Text('DESAFIO DA SEMANA', style: TextStyle(color: Colors.white, letterSpacing: .6, fontWeight: FontWeight.w800, fontSize: 11)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Text(quiz.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
        if (quiz.description.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(quiz.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.35)),
        ],
        const SizedBox(height: 16),
        EhButton(
          label: 'Participar agora',
          icon: Icons.play_arrow_rounded,
          inverted: true,
          fullWidth: false,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.quizQuestion, arguments: quiz),
        ),
      ]),
    );
  }

  Widget _quizCard(BuildContext context, FeedContent q, {required bool completed, required int score}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: EhCard(
        onTap: () => Navigator.pushNamed(context, completed ? AppRoutes.quizResult : AppRoutes.quizQuestion, arguments: q.id),
        child: Row(children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.quiz_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(q.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
              const SizedBox(height: 2),
              Text(q.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ]),
          ),
          const SizedBox(width: 8),
          if (completed)
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: .12), borderRadius: BorderRadius.circular(99)),
                child: Text('$score%', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              const SizedBox(height: 4),
              const Text('Rever', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
            ])
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: const Text('Fazer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ),
        ]),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final (icon, title, message) = _filter == 0
        ? (Icons.check_circle_outline, 'Sem quizzes pendentes', 'Explore mais conteúdos para desbloquear quizzes relacionados.')
        : (Icons.quiz_outlined, 'Ainda sem quizzes concluídos', 'Faça um quiz pendente para o ver aqui.');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Center(
        child: Column(children: [
          Icon(icon, size: 44, color: AppColors.outline),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text(message, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ]),
      ),
    );
  }
}
