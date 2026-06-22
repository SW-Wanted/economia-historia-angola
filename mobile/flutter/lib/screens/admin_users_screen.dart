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
  static const _filters = ['Todos', 'Escritores', 'Professores', 'Admins'];
  static const _roles = [UserRole.normal, UserRole.escritor, UserRole.professor, UserRole.admin, UserRole.normal];

  @override
  Widget build(BuildContext context) {
    final users = const MockDataService().ranking();
    return ScreenFrame(
      title: 'Gestao de Utilizadores',
      showBack: true,
      children: [
        const TextField(decoration: InputDecoration(hintText: 'Pesquisar utilizador', prefixIcon: Icon(Icons.search))),
        const SizedBox(height: 14),
        FilterChipsRow(labels: _filters, selected: _filter, onSelected: (i) => setState(() => _filter = i)),
        const SizedBox(height: 16),
        for (var i = 0; i < users.length; i++) ...[
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.pushNamed(context, AppRoutes.superAdmin),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: AppColors.surfaceContainer,
                        child: Text(users[i].initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users[i].name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                          Text(users[i].level, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(8)),
                      child: Text(_roles[i % _roles.length].label,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                    ),
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
}
