import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/community_category.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Detalhe de uma comunidade: cabeçalho, ação de aderir/sair, criar tópico e
/// lista dos fóruns/tópicos reais da comunidade.
class CommunityDetailScreen extends StatefulWidget {
  const CommunityDetailScreen({super.key, this.community});

  final CommunityCategory? community;

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  CommunityCategory? _community;
  List<Map<String, dynamic>> _forums = const [];
  bool _loading = true;
  bool _mutating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _community = widget.community;
    _load();
  }

  Future<void> _load() async {
    final id = widget.community?.id;
    if (id == null) {
      // Categoria local/mock sem backend — nada a carregar.
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await BackendService.instance.communityDetail(id);
      final forums = await BackendService.instance.communityForums(id);
      if (!mounted) return;
      setState(() {
        _community = detail;
        _forums = forums;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _toggleMembership() async {
    final community = _community;
    final id = community?.id;
    if (id == null || _mutating) return;
    setState(() => _mutating = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (community!.isMember || community.isPending) {
        await BackendService.instance.leaveCommunity(id);
        messenger.showSnackBar(
          const SnackBar(content: Text('Saiu da comunidade.'), behavior: SnackBarBehavior.floating),
        );
      } else {
        final status = await BackendService.instance.joinCommunity(id);
        messenger.showSnackBar(
          SnackBar(
            content: Text(status == CommunityViewerStatus.active
                ? 'Entrou na comunidade.'
                : 'Pedido enviado. Aguarda aprovação de um moderador.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      await _load();
    } catch (error) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(error.toString()), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _mutating = false);
    }
  }

  Future<void> _openCreateTopic() async {
    final created = await Navigator.pushNamed(
      context,
      AppRoutes.createTopic,
      arguments: _community?.id,
    );
    if (created == true && mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final community = _community;
    final name = community?.name ?? 'Comunidade';
    final description = community?.description ?? 'Debates e tópicos da comunidade.';

    return ScreenFrame(
      title: name,
      showBack: true,
      children: [
        _header(context, name, description, community),
        const SizedBox(height: 16),
        if (community?.id != null) _membershipButton(community!),
        if (community?.id != null) const SizedBox(height: 12),
        EhButton(
          label: 'Criar tópico',
          icon: Icons.add,
          onPressed: _openCreateTopic,
        ),
        const SizedBox(height: 24),
        const SectionTitle('Tópicos da comunidade'),
        const SizedBox(height: 12),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: AppLoadingIndicator(message: 'A carregar tópicos...')),
          )
        else if (_error != null)
          _stateMessage(context, _error!)
        else if (_forums.isEmpty)
          _stateMessage(context, 'Ainda não há tópicos nesta comunidade. Seja o primeiro a criar um.')
        else
          for (final forum in _forums) ...[
            _forumTile(context, forum),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  Widget _membershipButton(CommunityCategory community) {
    final (label, icon) = switch (community.viewerStatus) {
      CommunityViewerStatus.active => ('Sair da comunidade', Icons.logout),
      CommunityViewerStatus.pending => ('Cancelar pedido', Icons.hourglass_empty),
      CommunityViewerStatus.none => ('Aderir à comunidade', Icons.group_add),
    };
    final leaving = community.isMember || community.isPending;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _mutating ? null : _toggleMembership,
        icon: Icon(icon, size: 18),
        label: Text(_mutating ? 'Aguarde...' : label),
        style: OutlinedButton.styleFrom(
          foregroundColor: leaving ? AppColors.secondary : AppColors.primary,
          side: BorderSide(color: leaving ? AppColors.secondary : AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, String name, String description, CommunityCategory? community) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, Color(0xFF002336)],
                ),
              ),
            ),
          ),
          Positioned(right: -10, top: -12, child: Icon(Icons.groups_rounded, size: 110, color: Colors.white.withValues(alpha: .08))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.4)),
                if (community != null) ...[
                  const SizedBox(height: 12),
                  Text('${community.topics} tópicos • ${community.members} membros',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _forumTile(BuildContext context, Map<String, dynamic> forum) {
    final count = forum['_count'];
    final topics = count is Map ? int.tryParse(count['topics']?.toString() ?? '') ?? 0 : 0;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pushNamed(context, AppRoutes.forumTopic),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.forum_outlined, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(forum['name']?.toString() ?? 'Fórum',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('$topics ${topics == 1 ? 'tópico' : 'tópicos'}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _stateMessage(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
