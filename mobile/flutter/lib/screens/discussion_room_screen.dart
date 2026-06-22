import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/utils/responsive.dart';
import '../services/mock_data_service.dart';
import '../widgets/comment_tile.dart';

/// Sala de Discussão — secção de comentários PRIVADA controlada pelo professor.
/// (Decisão do resumo de sala de aula: professor decide quem comenta/visualiza.)
class DiscussionRoomScreen extends StatefulWidget {
  const DiscussionRoomScreen({super.key});

  @override
  State<DiscussionRoomScreen> createState() => _DiscussionRoomScreenState();
}

class _DiscussionRoomScreenState extends State<DiscussionRoomScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = const MockDataService().comments();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sala de Discussao'),
        actions: [
          IconButton(
            tooltip: 'Gerir participantes',
            icon: const Icon(Icons.manage_accounts_outlined),
            onPressed: () => _manageSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(AppSpacing.margin, 12, AppSpacing.margin, 4),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.navy.withValues(alpha: .25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, color: AppColors.navy, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Espaco privado. O professor define quem pode visualizar e comentar.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 12, AppSpacing.margin, 12),
                    children: [
                      Text('Tema: Ciclos Economicos 1975–1992',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                      const SizedBox(height: 12),
                      for (final c in comments) ...[CommentTile(comment: c), const SizedBox(height: 10)],
                    ],
                  ),
                ),
                Container(
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
                          decoration: const InputDecoration(hintText: 'Participar na discussao...'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: () {
                          if (_controller.text.trim().isEmpty) return;
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _manageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Participantes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final u in const MockDataService().ranking().take(4))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: AppColors.surfaceContainer, child: Text(u.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
                title: Text(u.name),
                trailing: Switch(value: true, activeThumbColor: AppColors.primary, onChanged: (_) {}),
              ),
          ],
        ),
      ),
    );
  }
}
