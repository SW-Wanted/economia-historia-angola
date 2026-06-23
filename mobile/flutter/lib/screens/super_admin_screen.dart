import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/app_user.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Painel de permissões (Super Admin) — T-25.
/// "No inicio todos podem tudo, mas precisa de uma permissao" (resumo de sala).
class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({super.key, this.user});

  /// Utilizador cujas permissoes estao a ser editadas.
  final AppUser? user;

  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  late UserRole _role = widget.user?.role ?? UserRole.escritor;
  late bool _canPublishJindungo = _role.index >= UserRole.professor.index;
  late bool _canModerate = _role.index >= UserRole.admin.index;
  late bool _canApproveAccess = _role == UserRole.professor || _role.index >= UserRole.admin.index;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final name = user?.name ?? 'Ana Muachia';
    final email = (user != null && user.email.isNotEmpty) ? user.email : 'ana.muachia@isptec.co.ao';
    final initials = user?.initials ?? 'AM';
    return ScreenFrame(
      title: 'Permissoes do Utilizador',
      showBack: true,
      children: [
        EhCard(
          child: Row(
            children: [
              CircleAvatar(radius: 26, backgroundColor: AppColors.surfaceContainer,
                  child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17)),
                    Text(email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Perfil de acesso'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: UserRole.values.map((r) {
            final active = r == _role;
            return ChoiceChip(
              label: Text(r.label),
              selected: active,
              showCheckmark: false,
              onSelected: (_) => setState(() => _role = r),
              labelStyle: TextStyle(color: active ? Colors.white : AppColors.secondary, fontWeight: FontWeight.w600),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              side: BorderSide(color: active ? AppColors.primary : AppColors.outlineVariant),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Permissoes especificas'),
        const SizedBox(height: 8),
        _permSwitch('Publicar textos com Jindungo', 'Categoria restrita de artigos.', _canPublishJindungo, (v) => setState(() => _canPublishJindungo = v)),
        _permSwitch('Moderar forum e comentarios', 'Editar, fixar e remover conteudos.', _canModerate, (v) => setState(() => _canModerate = v)),
        _permSwitch('Aprovar pedidos de acesso', 'Aceitar entradas em espacos privados.', _canApproveAccess, (v) => setState(() => _canApproveAccess = v)),
        const SizedBox(height: 24),
        EhButton(
          label: 'Guardar permissoes',
          icon: Icons.shield_outlined,
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permissoes atualizadas'), behavior: SnackBarBehavior.floating));
          },
        ),
      ],
    );
  }

  Widget _permSwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
        ),
        child: SwitchListTile(
          value: value,
          activeThumbColor: AppColors.primary,
          onChanged: onChanged,
          title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ),
      ),
    );
  }
}
