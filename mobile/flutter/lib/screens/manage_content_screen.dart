import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../services/feed_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Gerir os meus conteúdos — organiza os conteúdos criados pelo utilizador por
/// tipo (artigo, vídeo, podcast) e por categoria, permitindo criar, editar e
/// eliminar. Reutiliza o Design System; não altera regras de negócio.
class ManageContentScreen extends StatefulWidget {
  const ManageContentScreen({super.key});

  @override
  State<ManageContentScreen> createState() => _ManageContentScreenState();
}

class _ManageContentScreenState extends State<ManageContentScreen> {
  int _type = 0;
  static const _filters = ['Todos', 'Artigos', 'Vídeos', 'Podcasts'];

  /// Conteúdos "eliminados" (remoção visual em memória).
  final Set<String> _removed = {};

  FeedContentType? _typeFor(int i) => switch (i) {
        1 => FeedContentType.article,
        2 => FeedContentType.video,
        3 => FeedContentType.podcast,
        _ => null,
      };

  List<FeedContent> get _content {
    final type = _typeFor(_type);
    return FeedService.instance.catalog.where((c) {
      if (_removed.contains(c.id)) return false;
      final owned = c.type == FeedContentType.article ||
          c.type == FeedContentType.jindungo ||
          c.type == FeedContentType.video ||
          c.type == FeedContentType.podcast;
      if (!owned) return false;
      return type == null || c.type == type;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Agrupa por categoria.
    final byCategory = <String, List<FeedContent>>{};
    for (final c in _content) {
      byCategory.putIfAbsent(c.category, () => []).add(c);
    }
    final categories = byCategory.keys.toList()..sort();

    return ScreenFrame(
      title: 'Os Meus Conteúdos',
      showBack: true,
      showNotifications: false,
      children: [
        EhButton(
          label: 'Criar conteúdo',
          icon: Icons.add,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.createContent),
        ),
        const SizedBox(height: 16),
        FilterChipsRow(labels: _filters, selected: _type, onSelected: (i) => setState(() => _type = i)),
        const SizedBox(height: 16),
        if (categories.isEmpty)
          _empty(context)
        else
          for (final cat in categories) ...[
            SectionTitle(cat),
            const SizedBox(height: 10),
            for (final c in byCategory[cat]!) _row(context, c),
            const SizedBox(height: 14),
          ],
      ],
    );
  }

  Widget _row(BuildContext context, FeedContent c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: EhCard(
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(c.type.icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.5)),
              Text('${c.type.label} · ${formatCount(c.views)} visualizações',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
            ]),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.secondary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (v) => switch (v) {
              'edit' => _edit(c),
              'access' => _manageAccess(c),
              _ => _confirmDelete(c),
            },
            itemBuilder: (context) => [
              _menuItem('edit', Icons.edit_outlined, 'Editar'),
              // Gerir acessos só faz sentido para textos Jindungo (restritos).
              if (c.type == FeedContentType.jindungo)
                _menuItem('access', Icons.lock_open_outlined, 'Gerir acessos'),
              _menuItem('delete', Icons.delete_outline, 'Eliminar', danger: true),
            ],
          ),
        ]),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label, {bool danger = false}) => PopupMenuItem(
        value: value,
        child: Row(children: [
          Icon(icon, size: 19, color: danger ? AppColors.error : AppColors.textMuted),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: danger ? AppColors.error : null)),
        ]),
      );

  void _edit(FeedContent c) {
    Navigator.pushNamed(context, AppRoutes.publishContent, arguments: {'type': _typeArg(c.type)});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text('A editar: ${c.title}')));
  }

  /// Abre a gestão de acessos (convidados) de um texto Jindungo.
  void _manageAccess(FeedContent c) {
    Navigator.pushNamed(
      context,
      AppRoutes.jindungoInvitees,
      arguments: {'contentId': c.id, 'title': c.title},
    );
  }

  String _typeArg(FeedContentType t) => switch (t) {
        FeedContentType.video => 'video',
        FeedContentType.podcast => 'podcast',
        _ => 'texto',
      };

  Future<void> _confirmDelete(FeedContent c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar conteúdo'),
        content: Text('Tem a certeza que deseja eliminar "${c.title}"? Esta ação não pode ser anulada.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      setState(() => _removed.add(c.id));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Conteúdo eliminado')));
    }
  }

  Widget _empty(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: Column(children: [
            const Icon(Icons.inbox_outlined, size: 44, color: AppColors.outline),
            const SizedBox(height: 12),
            Text('Sem conteúdos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Crie o seu primeiro conteúdo com o botão acima.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ]),
        ),
      );
}
