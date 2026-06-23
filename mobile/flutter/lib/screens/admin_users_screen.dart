import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/app_user.dart';
import '../services/mock_data_service.dart';
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
  static const _filters = ['Todos', 'Escritores', 'Professores', 'Admins'];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matchesFilter(AppUser u) => switch (_filter) {
        1 => u.role == UserRole.escritor,
        2 => u.role == UserRole.professor,
        3 => u.isAdmin,
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final users = const MockDataService()
        .users()
        .where(_matchesFilter)
        .where((u) => query.isEmpty || u.name.toLowerCase().contains(query))
        .toList();
    return ScreenFrame(
      title: 'Gestao de Utilizadores',
      showBack: true,
      children: [
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(hintText: 'Pesquisar utilizador', prefixIcon: Icon(Icons.search)),
        ),
        const SizedBox(height: 14),
        FilterChipsRow(labels: _filters, selected: _filter, onSelected: (i) => setState(() => _filter = i)),
        const SizedBox(height: 16),
        if (users.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(
              child: Text('Nenhum utilizador encontrado',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
            ),
          ),
        for (final user in users) ...[
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.pushNamed(context, AppRoutes.superAdmin, arguments: user),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: AppColors.surfaceContainer,
                        child: Text(user.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                          Text(user.course, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                        ],
                      ),
                    ),
                    _roleBadge(context, user.role),
                    const Icon(Icons.chevron_right, color: AppColors.outline),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _roleBadge(BuildContext context, UserRole role) {
    final highlight = role == UserRole.superAdmin || role == UserRole.admin;
    final color = highlight ? AppColors.primary : AppColors.secondary;
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary.withValues(alpha: .12) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(role.label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
