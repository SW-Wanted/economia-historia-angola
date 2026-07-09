import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../models/profile_stats.dart';
import '../services/app_settings.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Dados reais do perfil carregados de uma só vez do backend.
class _ProfileData {
  const _ProfileData({
    required this.user,
    required this.stats,
    required this.interests,
    required this.communities,
  });

  final AppUser user;
  final ProfileStats? stats;
  final List<String> interests;
  final List<String> communities;
}

/// Perfil como painel pessoal: quem sou, o que aprendi, onde participo e qual o
/// meu progresso. Para Escritor/Admin/Super Admin apresenta ainda um Painel de
/// Gestão consoante os privilégios. Os dados (identidade, estatísticas,
/// interesses e comunidades) vêm do backend; secções sem dados reais são
/// escondidas em vez de mostrarem valores fictícios.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<_ProfileData> _dataF = _load();

  Future<_ProfileData> _load() async {
    final backend = BackendService.instance;
    final results = await Future.wait([
      backend.currentUser(),
      backend.profileStats(),
      backend.myProfileExtras(),
    ]);
    final user = results[0] as AppUser;
    final stats = results[1] as ProfileStats?;
    final extras = results[2] as ({List<String> interests, List<String> communities});
    return _ProfileData(
      user: user,
      stats: stats,
      interests: extras.interests,
      communities: extras.communities,
    );
  }

  Future<void> _openEditProfile() async {
    await Navigator.pushNamed(context, AppRoutes.editProfile);
    if (!mounted) return;
    setState(() => _dataF = _load());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Perfil',
      showBack: true,
      showNotifications: false,
      paddingBottom: 28,
      children: [
        FutureBuilder<_ProfileData>(
          future: _dataF,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(child: AppLoadingIndicator(message: 'A carregar o seu perfil...')),
              );
            }
            final data = snapshot.data;
            if (data == null) {
              return const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(child: Text('Não foi possível carregar o perfil.')),
              );
            }
            return _content(context, data);
          },
        ),
      ],
    );
  }

  Widget _content(BuildContext context, _ProfileData data) {
    final user = data.user;
    final isWriter = user.canPublish;
    final isManager = user.canPublish || user.canModerate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context, user, isWriter),
        if (data.interests.isNotEmpty) ...[
          const SizedBox(height: 22),
          _interests(context, data.interests),
        ],
        if (data.stats != null) ...[
          const SizedBox(height: 24),
          _stats(context, user, data.stats!),
        ],
        if (data.communities.isNotEmpty) ...[
          const SizedBox(height: 24),
          _communities(context, data.communities),
        ],
        const SizedBox(height: 24),
        _myLibrary(context),
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
                  // Capa real do utilizador, quando definida.
                  if (user.coverUrl != null)
                    Positioned.fill(
                      child: Image.network(user.coverUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox.shrink()),
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
                    backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                    child: user.avatarUrl != null
                        ? null
                        : Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
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
          // Só mostra a data de adesão e a província quando são dados reais.
          if (user.memberSince != null)
            _meta(context, Icons.calendar_today_outlined, 'Membro desde ${_memberSince(user.memberSince!)}'),
          if (user.province.isNotEmpty) _meta(context, Icons.place_outlined, user.province),
        ]),
        // Biografia real do utilizador — omitida quando não está preenchida.
        if (user.bio != null) ...[
          const SizedBox(height: 10),
          Text(user.bio!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.4)),
        ],
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _openEditProfile,
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

  /// "mar. 2024" a partir da data de criação da conta.
  String _memberSince(DateTime date) {
    const months = ['jan.', 'fev.', 'mar.', 'abr.', 'mai.', 'jun.', 'jul.', 'ago.', 'set.', 'out.', 'nov.', 'dez.'];
    final local = date.toLocal();
    return '${months[local.month - 1]} ${local.year}';
  }

  Widget _roleChip(BuildContext context, AppUser user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(99)),
        child: Text(user.role.label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 11)),
      );

  // ------------------------------------------------------------ Interesses

  Widget _interests(BuildContext context, List<String> interests) => _section(context, 'Áreas de Interesse',
      child: Wrap(spacing: 8, runSpacing: 8, children: [for (final c in interests) _chip(c)]));

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

  Widget _stats(BuildContext context, AppUser user, ProfileStats stats) {
    final items = <Widget>[
      _statCard(context, Icons.bolt, '${stats.points}', 'Pontos'),
      _statCard(context, Icons.menu_book_outlined, '${stats.contentsCompleted}', 'Conteúdos', color: AppColors.tertiary),
      _statCard(context, Icons.quiz_outlined, '${stats.quizzesTaken}', 'Quizzes', color: AppColors.success),
      _statCard(context, Icons.emoji_events_outlined, stats.rank == null ? '—' : '#${stats.rank}', 'Ranking'),
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

  /// Comunidades reais em que o utilizador participa (memberships de
  /// `/users/me`). Só é apresentada quando existem — sem exemplos fictícios.
  Widget _communities(BuildContext context, List<String> communities) {
    return _section(context, 'As Minhas Comunidades', child: Column(children: [
      for (final name in communities)
        _rowTile(
          context,
          leading: const Icon(Icons.groups, color: AppColors.navy, size: 20),
          leadingBg: AppColors.navy.withValues(alpha: .12),
          title: name,
          titleColor: AppColors.navy,
          tag: 'Participa',
          onTap: () => Navigator.pushNamed(context, AppRoutes.community),
        ),
    ]));
  }

  // ------------------------------------------------------- Minha Biblioteca

  /// Acesso rápido à biblioteca pessoal — em especial aos conteúdos guardados.
  /// Disponível para qualquer utilizador (não só escritores/gestores).
  Widget _myLibrary(BuildContext context) {
    return _section(context, 'A Minha Biblioteca', child: Column(children: [
      _rowTile(
        context,
        leading: const Icon(Icons.library_books_outlined, color: AppColors.primary, size: 20),
        leadingBg: AppColors.primary.withValues(alpha: .10),
        title: 'Minha biblioteca',
        subtitle: 'Guardados, leituras em progresso e offline.',
        onTap: () => Navigator.pushNamed(context, AppRoutes.library),
      ),
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
