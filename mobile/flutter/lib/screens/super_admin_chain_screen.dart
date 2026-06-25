import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/app_user.dart';
import '../services/mock_data_service.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Cadeia hierárquica de Super Admins (Grau 0 → 1 → 2 ...) com a regra de sucessão.
class SuperAdminChainScreen extends StatelessWidget {
  const SuperAdminChainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supers = const MockDataService()
        .users()
        .where((u) => u.isSuperAdmin)
        .toList()
      ..sort((a, b) => (a.superAdminGrade ?? 99).compareTo(b.superAdminGrade ?? 99));

    return ScreenFrame(title: 'Cadeia de Super Admins', showBack: true, children: [
      Text('Hierarquia e sucessão', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
      const SizedBox(height: 6),
      Text(
        'Os Super Admins formam uma cadeia por grau. O Grau 0 tem autoridade máxima '
        'e não pode ser removido. Se sair, cada grau sobe uma posição.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
      ),
      const SizedBox(height: 24),
      const SectionTitle('Cadeia atual'),
      const SizedBox(height: 16),
      for (var i = 0; i < supers.length; i++) ...[
        _node(context, supers[i], isFirst: i == 0),
        if (i < supers.length - 1) _connector(),
      ],
      const SizedBox(height: 24),
      const SectionTitle('Regra de sucessão'),
      const SizedBox(height: 12),
      _ruleCard(context),
    ]);
  }

  Widget _node(BuildContext context, AppUser u, {required bool isFirst}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFirst ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isFirst ? AppColors.primary : AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: isFirst ? Colors.white.withValues(alpha: .18) : AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('G${u.superAdminGrade}',
                  style: TextStyle(color: isFirst ? Colors.white : AppColors.primary, fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(u.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 16, color: isFirst ? Colors.white : null)),
                    ),
                    if (isFirst) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.workspace_premium, size: 16, color: Colors.white),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isFirst ? 'Super Admin principal · autoridade máxima' : 'Super Admin · grau ${u.superAdminGrade}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isFirst ? Colors.white70 : AppColors.secondary),
                ),
              ],
            ),
          ),
          if (isFirst)
            const Icon(Icons.lock, color: Colors.white, size: 18)
          else
            const Icon(Icons.swap_vert, color: AppColors.secondary, size: 18),
        ],
      ),
    );
  }

  Widget _connector() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Center(child: Icon(Icons.arrow_downward, color: AppColors.outline, size: 22)),
    );
  }

  Widget _ruleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rule(context, 'Se o Grau 0 sair, o Grau 1 torna-se Grau 0.'),
          _rule(context, 'O Grau 2 torna-se Grau 1, e assim sucessivamente.'),
          _rule(context, 'Um Super Admin nunca pode remover outro de grau superior.'),
          _rule(context, 'O Grau 0 nunca pode ser removido por outro Super Admin.'),
        ],
      ),
    );
  }

  Widget _rule(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4))),
        ]),
      );
}
