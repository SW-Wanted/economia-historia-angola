import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/pending_content.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/screen_frame.dart';

/// Aprovação de conteúdos submetidos por Escritores (Admin+).
///
/// Carrega os conteúdos reais em estado PENDENTE do backend e permite aprová-los
/// (passam a PUBLICADO e ficam visíveis para todos) ou devolvê-los ao autor
/// (voltam a RASCUNHO). Sem dados fictícios.
class ContentModerationScreen extends StatefulWidget {
  const ContentModerationScreen({super.key});

  @override
  State<ContentModerationScreen> createState() => _ContentModerationScreenState();
}

class _ContentModerationScreenState extends State<ContentModerationScreen> {
  List<PendingContent> _items = const [];
  bool _loading = true;
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await BackendService.instance.pendingContents();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _decide(PendingContent item, bool approve) async {
    if (_busy.contains(item.id)) return;

    // Ao devolver/rejeitar, pedimos o motivo — enviado ao autor na notificação.
    String? notes;
    if (!approve) {
      notes = await _askRejectionReason(item);
      if (notes == null) return; // cancelou
    }

    setState(() => _busy.add(item.id));
    try {
      // Aprovar → PUBLICADO (visível a todos). Devolver → REJEITADO com motivo
      // (o autor recebe uma notificação de moderação em tempo real).
      await BackendService.instance.changeContentStatus(
        item.id,
        approve ? 'PUBLISHED' : 'REJECTED',
        notes: notes,
      );
      if (approve) await FeedService.instance.load(force: true);
      if (!mounted) return;
      setState(() => _items = _items.where((c) => c.id != item.id).toList());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? '"${item.title}" aprovado e publicado.' : '"${item.title}" devolvido ao autor.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível concluir: $error'), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _busy.remove(item.id));
    }
  }

  /// Diálogo que recolhe o motivo da rejeição. Devolve o texto (pode ser vazio
  /// se o moderador optar por devolver sem justificação) ou `null` se cancelar.
  Future<String?> _askRejectionReason(PendingContent item) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Devolver ao autor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explique ao autor o que precisa de ser corrigido em "${item.title}".',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                hintText: 'Ex.: fonte em falta, título pouco claro…',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Devolver'),
          ),
        ],
      ),
    );
    controller.dispose();
    return reason;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Aprovação de Conteúdos',
      showBack: true,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.navy.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.navy.withValues(alpha: .2)),
          ),
          child: Row(children: [
            const Icon(Icons.fact_check_outlined, color: AppColors.navy, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Conteúdos submetidos por Escritores aguardam a sua aprovação.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy)),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(
              child: Column(children: [
                const Icon(Icons.inbox_outlined, size: 56, color: AppColors.outline),
                const SizedBox(height: 12),
                Text('Sem conteúdos pendentes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
              ]),
            ),
          )
        else
          for (final item in _items) ...[
            _card(context, item),
            const SizedBox(height: 14),
          ],
      ],
    );
  }

  Widget _card(BuildContext context, PendingContent item) {
    final busy = _busy.contains(item.id);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            EhIllustration(scene: _sceneFor(item.type), fallbackIcon: _iconFor(item.type), height: 120),
            Positioned(
              left: 12, top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                child: Text(_typeLabel(item.type).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text('por ${item.author}${item.timeAgo.isNotEmpty ? ' · ${item.timeAgo}' : ''}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                if (item.excerpt.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(item.excerpt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                ],
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: busy ? null : () => _decide(item, false),
                      icon: const Icon(Icons.close),
                      label: const Text('Devolver'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: busy ? null : () => _decide(item, true),
                      icon: busy
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.check),
                      label: const Text('Aprovar'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    final t = type.toLowerCase();
    if (t.contains('video')) return 'Vídeo';
    if (t.contains('audio') || t.contains('podcast')) return 'Podcast';
    return 'Artigo';
  }

  IconData _iconFor(String type) {
    final t = type.toLowerCase();
    if (t.contains('video')) return Icons.play_circle_outline;
    if (t.contains('audio') || t.contains('podcast')) return Icons.mic_none_outlined;
    return Icons.menu_book_outlined;
  }

  EhScene _sceneFor(String type) {
    final t = type.toLowerCase();
    if (t.contains('audio') || t.contains('podcast')) return EhScene.podcast;
    return EhScene.market;
  }
}
