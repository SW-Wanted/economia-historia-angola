import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../services/backend_service.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/screen_frame.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  int _filter = 0;
  final TextEditingController _search = TextEditingController();
  static const _filters = ['Todos', 'Utilizadores', 'Escritores', 'Admins', 'Super Admins'];

  List<AppUser>? _all; // null enquanto carrega

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final users = await BackendService.instance.adminUsers();
    if (!mounted) return;
    setState(() => _all = users);
  }

  bool _matchesFilter(AppUser u) => switch (_filter) {
        1 => u.role == UserRole.utilizador,
        2 => u.role == UserRole.escritor,
        3 => u.role == UserRole.admin,
        4 => u.role == UserRole.superAdmin,
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final me = BackendService.instance.cachedUser;
    final query = _search.text.trim().toLowerCase();
    final all = _all;
    final users = (all ?? const <AppUser>[])
        .where(_matchesFilter)
        .where((u) => query.isEmpty || u.name.toLowerCase().contains(query))
        .toList();
    return ScreenFrame(
      title: 'Gestão de Utilizadores',
      showBack: true,
      children: [
        _permissionNotice(context, me),
        const SizedBox(height: 16),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(hintText: 'Pesquisar utilizador', prefixIcon: Icon(Icons.search)),
        ),
        const SizedBox(height: 14),
        FilterChipsRow(labels: _filters, selected: _filter, onSelected: (i) => setState(() => _filter = i)),
        const SizedBox(height: 16),
        if (all == null)
          const Padding(padding: EdgeInsets.only(top: 48), child: Center(child: CircularProgressIndicator()))
        else if (users.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(
              child: Text('Nenhum utilizador encontrado',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
            ),
          ),
        for (final user in users) ...[
          _userTile(context, me, user),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _permissionNotice(BuildContext context, AppUser me) {
    final text = me.isSuperAdmin
        ? (me.isFounder
            ? 'É o Super Admin fundador (grau 0). Pode gerir todos os perfis, incluindo outros Super Admins.'
            : 'Como Super Admin (grau ${me.superAdminGrade}), gere perfis inferiores e Super Admins de grau maior.')
        : 'Como Admin, pode gerir apenas Utilizadores e Escritores. Não pode gerir outros Admins.';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navy.withValues(alpha: .2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.navy, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _userTile(BuildContext context, AppUser me, AppUser user) {
    final manageable = me.canManage(user);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.pushNamed(context, AppRoutes.superAdmin, arguments: user);
          // Recarrega ao voltar, refletindo mudanças de papel/estado/remoção.
          if (mounted) _load();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.surfaceContainer,
                child: Text(user.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15))),
                        if (user.isFounder) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.workspace_premium, size: 16, color: AppColors.warning),
                        ],
                      ],
                    ),
                    Text('${user.course} • ${user.institution}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
              _roleBadge(context, user),
              Icon(manageable ? Icons.chevron_right : Icons.lock_outline,
                  color: manageable ? AppColors.outline : AppColors.outlineVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleBadge(BuildContext context, AppUser user) {
    final role = user.role;
    final highlight = role == UserRole.superAdmin || role == UserRole.admin;
    final color = highlight ? AppColors.primary : AppColors.secondary;
    final label = role == UserRole.superAdmin ? 'Super Admin · G${user.superAdminGrade ?? '-'}' : role.label;
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary.withValues(alpha: .12) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11)),
    );
  }
}
