import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../models/feed.dart';
import '../services/app_settings.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Perfil como painel pessoal: quem sou, o que aprendi, o que publiquei, onde
/// participo e qual o meu progresso. Para Escritor/Admin/Super Admin apresenta
/// ainda um Painel de Gestão consoante os privilégios. Reutiliza componentes e
/// dados existentes; não altera navegação, permissões nem regras.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    final fs = FeedService.instance;
    final isWriter = user.canPublish;
    final isManager = user.canPublish || user.canModerate;

    return ScreenFrame(
      title: 'Perfil',
      showBack: true,
      showNotifications: false,
      paddingBottom: 28,
      children: [
        _header(context, user, isWriter),
        const SizedBox(height: 22),
        _interests(context, fs),
        const SizedBox(height: 24),
        _stats(context, user),
        const SizedBox(height: 24),
        _communities(context, fs),
        const SizedBox(height: 24),
        _forums(context, fs),
        if (isManager) ...[
          const SizedBox(height: 24),
          _features(context, user),
        ],
        const SizedBox(height: 24),
        _accountFooter(context),
      ],
    );
  }

  // --------------------------------------------------- Cabeçalho (Quem sou)

  Widget _header(BuildContext context, AppUser user, bool isWriter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Capa + fotografia sobreposta.
        SizedBox(
          height: 120 + 44,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                    ),
                  ),
                  Positioned(right: -16, top: -12, child: Icon(Icons.history_edu, size: 120, color: Colors.white.withValues(alpha: .10))),
                ]),
              ),
              Positioned(
                left: 16, top: 120 - 44,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primary,
                    child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text(user.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 21))),
          if (AppSettings.instance.profileLocked) _lockedBadge(context),
        ]),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          _roleChip(context, user),
          _meta(context, Icons.calendar_today_outlined, 'Membro desde mar. 2024'),
          _meta(context, Icons.place_outlined, user.province),
        ]),
        const SizedBox(height: 10),
        Text('Estudante de economia apaixonado pela história económica de Angola.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.4)),
        if (isWriter) ...[
          const SizedBox(height: 12),
          _kv(context, Icons.workspace_premium_outlined, 'Especialização', 'Economia colonial'),
          _kv(context, Icons.account_balance_outlined, 'Instituição', user.institution),
          _kv(context, Icons.school_outlined, 'Formação', 'Mestrado em Economia'),
        ],
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Editar Perfil'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lockedBadge(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.navy.withValues(alpha: .3)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline, size: 13, color: AppColors.navy),
          SizedBox(width: 4),
          Text('Bloqueado', style: TextStyle(color: AppColors.navy, fontSize: 10.5, fontWeight: FontWeight.w800)),
        ]),
      );

  Widget _meta(BuildContext context, IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: AppColors.secondary),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ]);

  Widget _kv(BuildContext context, IconData icon, String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('$k: ', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          Expanded(child: Text(v, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700))),
        ]),
      );

  Widget _roleChip(BuildContext context, AppUser user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(99)),
        child: Text(user.role.label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 11)),
      );

  // ------------------------------------------------------------ Interesses

  Widget _interests(BuildContext context, FeedService fs) => _section(context, 'Áreas de Interesse',
      child: Wrap(spacing: 8, runSpacing: 8, children: [for (final c in fs.favoriteCategories) _chip(c)]));

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.primary.withValues(alpha: .25)),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
      );

  // -------------------------------------------------- Estatísticas (Progresso)

  Widget _stats(BuildContext context, AppUser user) {
    final items = <Widget>[
      _statCard(context, Icons.bolt, '${user.points}', 'Pontos'),
      if (AppSettings.instance.showReadingStats)
        _statCard(context, Icons.schedule, '3h20', 'Leitura', color: AppColors.navy),
      _statCard(context, Icons.menu_book_outlined, '20', 'Conteúdos', color: AppColors.tertiary),
      _statCard(context, Icons.quiz_outlined, '8', 'Quizzes', color: AppColors.success),
      _statCard(context, Icons.emoji_events_outlined, '#14', 'Ranking'),
    ];
    return _section(context, 'O Meu Progresso', child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.02,
      children: items,
    ));
  }

  /// Cartão de estatística compacto.
  Widget _statCard(BuildContext context, IconData icon, String value, String label, {Color? color}) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: c, size: 19),
        const SizedBox(height: 5),
        Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: c, fontSize: 16)),
        const SizedBox(height: 1),
        Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 10.5)),
      ]),
    );
  }

  // ------------------------------------------------------------ Comunidades

  Widget _communities(BuildContext context, FeedService fs) {
    final owned = fs.ownedCommunities.toSet();
    return _section(context, 'As Minhas Comunidades', child: Column(children: [
      for (final name in fs.userCommunities)
        _rowTile(
          context,
          leading: const Icon(Icons.groups, color: AppColors.navy, size: 20),
          leadingBg: AppColors.navy.withValues(alpha: .12),
          title: 'eh/${name.replaceAll(' ', '')}',
          titleColor: AppColors.navy,
          tag: owned.contains(name) ? null : 'Participa',
          onManage: owned.contains(name) ? () => _manageOwned(context, 'comunidade', name) : null,
          onTap: () => Navigator.pushNamed(context, AppRoutes.community),
        ),
    ]));
  }

  // ---------------------------------------------------------------- Fóruns

  Widget _forums(BuildContext context, FeedService fs) {
    final owned = fs.ownedCommunities.toSet();
    final forums = fs.catalog.where((c) => c.type == FeedContentType.forum).take(4).toList();
    return _section(context, 'Os Meus Fóruns', child: Column(children: [
      for (final c in forums)
        () {
          final isOwn = c.community != null && owned.contains(c.community);
          return _rowTile(
            context,
            leading: Icon(c.type.icon, color: AppColors.primary, size: 20),
            leadingBg: AppColors.surfaceContainer,
            title: c.title,
            subtitle: isOwn ? 'Criado · eh/${c.community!.replaceAll(' ', '')}' : 'Participou · público',
            onManage: isOwn ? () => _manageOwned(context, 'fórum', c.title) : null,
            onTap: () => Navigator.pushNamed(context, c.isRestricted ? AppRoutes.restrictedContent : AppRoutes.forumTopic),
          );
        }(),
    ]));
  }

  // ------------------------------------------------------- Funcionalidades

  Widget _features(BuildContext context, AppUser user) {
    final tiles = <Widget>[
      if (user.canPublish)
        _rowTile(
          context,
          leading: const Icon(Icons.folder_copy_outlined, color: AppColors.primary, size: 20),
          leadingBg: AppColors.primary.withValues(alpha: .10),
          title: 'Gerir os meus conteúdos',
          subtitle: 'Artigos, vídeos e podcasts criados por si.',
          onTap: () => Navigator.pushNamed(context, AppRoutes.manageContent),
        ),
      if (user.canPublish || user.canModerate)
        _rowTile(
          context,
          leading: const Icon(Icons.insert_chart_outlined_rounded, color: AppColors.primary, size: 20),
          leadingBg: AppColors.primary.withValues(alpha: .10),
          title: 'Painel de Gestão',
          subtitle: 'Impacto das publicações e administração.',
          onTap: () => Navigator.pushNamed(context, AppRoutes.managementPanel),
        ),
    ];
    return _section(context, 'Gestão', child: Column(children: tiles));
  }

  /// Ações de gestão (editar/eliminar) de conteúdo próprio (comunidade/fórum).
  void _manageOwned(BuildContext context, String kind, String name) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: 12 + MediaQuery.viewPaddingOf(sheetContext).bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Row(children: [
              Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge)),
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
            title: const Text('Editar'),
            onTap: () {
              Navigator.pop(sheetContext);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text('A editar $kind: $name')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text('Eliminar', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pop(sheetContext);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text('$kind eliminado')));
            },
          ),
          const SizedBox(height: 6),
        ]),
      ),
    );
  }

  // -------------------------------------------------------- Conta (rodapé)

  Widget _accountFooter(BuildContext context) => _section(context, 'Conta', child: Column(children: [
        _rowTile(
          context,
          leading: const Icon(Icons.settings_outlined, color: AppColors.primary, size: 20),
          leadingBg: AppColors.primary.withValues(alpha: .10),
          title: 'Definições',
          subtitle: 'Palavra-passe, aparência, privacidade…',
          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
        ),
        _rowTile(
          context,
          leading: const Icon(Icons.help_outline, color: AppColors.primary, size: 20),
          leadingBg: AppColors.primary.withValues(alpha: .10),
          title: 'Central de ajuda',
          onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter),
        ),
        _rowTile(
          context,
          leading: const Icon(Icons.logout, color: AppColors.error, size: 20),
          leadingBg: AppColors.error.withValues(alpha: .10),
          title: 'Terminar sessão',
          titleColor: AppColors.error,
          onTap: () => _logout(context),
        ),
      ]));

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await BackendService.instance.logout();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
  }

  // ------------------------------------------------------------ utilitários

  Widget _rowTile(
    BuildContext context, {
    required Widget leading,
    required Color leadingBg,
    required String title,
    String? subtitle,
    String? tag,
    Color? titleColor,
    VoidCallback? onManage,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
            ),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: leadingBg, borderRadius: BorderRadius.circular(11)),
                child: leading,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14, color: titleColor)),
                  if (subtitle != null)
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
                ]),
              ),
              if (onManage != null)
                OutlinedButton.icon(
                  onPressed: onManage,
                  icon: const Icon(Icons.tune, size: 15),
                  label: const Text('Gerir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: .5)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                )
              else if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(99)),
                  child: Text(tag, style: const TextStyle(color: AppColors.primary, fontSize: 10.5, fontWeight: FontWeight.w800)),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.outline),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, {required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SectionTitle(title), const SizedBox(height: 12), child],
      );
}
