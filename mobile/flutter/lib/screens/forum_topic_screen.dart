import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
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
    final comments = const MockDataService().comments();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topico'),
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
                  ),
                ),
                _composer(),
              ],
            ),
          ),
        ),
      ),
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
            onPressed: _send,
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
