import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/backend_service.dart';
import '../widgets/screen_frame.dart';

/// Painel de aprovação de pedidos de acesso a textos Jindungo (Admin+).
///
/// Lista os pedidos reais em estado PENDENTE do backend e permite conceder
/// (o requerente passa a poder ler o texto) ou recusar o acesso. O requerente é
/// notificado da decisão em tempo real.
class JindungoAccessScreen extends StatefulWidget {
  const JindungoAccessScreen({super.key});

  @override
  State<JindungoAccessScreen> createState() => _JindungoAccessScreenState();
}

class _JindungoAccessScreenState extends State<JindungoAccessScreen> {
  List<Map<String, dynamic>> _items = const [];
  bool _loading = true;
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await BackendService.instance.jindungoAccessRequests();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _decide(Map<String, dynamic> item, bool approve) async {
    final id = item['id']?.toString() ?? '';
    if (id.isEmpty || _busy.contains(id)) return;
    setState(() => _busy.add(id));
    try {
      await BackendService.instance.reviewAccessRequest(id, approve: approve);
      if (!mounted) return;
      setState(() => _items = _items.where((r) => r['id']?.toString() != id).toList());
      final who = _userName(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? 'Acesso concedido a $who.' : 'Pedido de $who recusado.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível concluir: $error'), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  String _userName(Map<String, dynamic> item) {
    final user = item['user'];
    return user is Map ? user['name']?.toString() ?? 'Utilizador' : 'Utilizador';
  }

  String _contentTitle(Map<String, dynamic> item) {
    final content = item['content'];
    return content is Map ? content['title']?.toString() ?? 'Texto Jindungo' : 'Texto Jindungo';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Acessos Jindungo',
      showBack: true,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
          ),
          child: Row(children: [
            const Icon(Icons.local_fire_department, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Utilizadores pediram acesso a textos Jindungo. Conceda apenas a quem deve poder ler.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary)),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        if (_loading)
          const Padding(padding: EdgeInsets.only(top: 48), child: Center(child: CircularProgressIndicator()))
        else if (_items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(
              child: Column(children: [
                const Icon(Icons.inbox_outlined, size: 56, color: AppColors.outline),
                const SizedBox(height: 12),
                Text('Sem pedidos pendentes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
              ]),
            ),
          )
        else
          for (final item in _items) ...[
            _card(context, item),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  Widget _card(BuildContext context, Map<String, dynamic> item) {
    final id = item['id']?.toString() ?? '';
    final busy = _busy.contains(id);
    final reason = item['reason']?.toString();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: AppColors.surfaceContainer,
              child: Text(_initials(_userName(item)),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_userName(item), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                  Text('Pediu acesso a "${_contentTitle(item)}"',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                ],
              ),
            ),
          ]),
          if (reason != null && reason.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('"$reason"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted, fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: busy ? null : () => _decide(item, false),
                icon: const Icon(Icons.close),
                label: const Text('Recusar'),
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
                    : const Icon(Icons.lock_open_rounded),
                label: const Text('Conceder'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.success),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
