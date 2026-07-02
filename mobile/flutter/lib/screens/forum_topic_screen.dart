import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/responsive.dart';
import '../services/mock_data_service.dart';
import '../widgets/comment_tile.dart';
import '../widgets/eh_card.dart';

class ForumTopicScreen extends StatefulWidget {
  const ForumTopicScreen({super.key});

  @override
  State<ForumTopicScreen> createState() => _ForumTopicScreenState();
}

class _ForumTopicScreenState extends State<ForumTopicScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentario publicado'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    // `arguments == true` → modo prévia (visitante): mostra o tópico mas oculta
    // os comentários (só visíveis após entrar).
    final preview = ModalRoute.of(context)?.settings.arguments == true;
    final comments = const MockDataService().comments();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tópico',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Denunciar',
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => Navigator.pushNamed(context, '/report'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 16, AppSpacing.margin, 16),
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(8)),
                            child: Text('PROFESSOR', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                          ),
                          const SizedBox(width: 8),
                          Text('há 2 horas', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('O impacto das ferrovias no sec. XX?', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
                      const SizedBox(height: 12),
                      const EhCard(
                        child: Text(
                          'As ferrovias foram decisivas para ligar zonas produtivas aos portos, reorganizando mercados regionais e rotas de trabalho. Que outros efeitos de longo prazo conseguimos identificar?',
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (preview)
                        _commentsGate(context, comments.length)
                      else ...[
                        Row(
                          children: [
                            Text('${comments.length} comentarios', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                            const Spacer(),
                            Text('Mais recentes', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                            const Icon(Icons.expand_more, size: 18, color: AppColors.secondary),
                          ],
                        ),
                        const SizedBox(height: 12),
                        for (final c in comments) ...[CommentTile(comment: c), const SizedBox(height: 10)],
                      ],
                    ],
                  ),
                ),
                if (!preview) _composer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _commentsGate(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text('$count comentários reservados', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15))),
        ]),
        const SizedBox(height: 6),
        Text('Entre para ver a discussão e participar. Os comentários são exclusivos para membros.',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.35)),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register1),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Criar conta para ver comentários'),
          ),
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
          style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
          child: const Text('Já tenho conta — Entrar'),
        ),
      ]),
    );
  }

  Widget _composer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 10, AppSpacing.margin, 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Escreva uma resposta...'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Enviar comentário',
            onPressed: _send,
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
