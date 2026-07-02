import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/app_user.dart';
import '../services/backend_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Gestão de perfil e permissões de um utilizador.
/// Reflete a hierarquia: quem pode promover/despromover/bloquear quem.
class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({super.key, this.user});

  final AppUser? user;

  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  late AppUser _target;
  late UserRole _role;

  final AppUser _me = BackendService.instance.cachedUser;

  @override
  void initState() {
    super.initState();
    // Aberto sempre com um utilizador real (a partir da gestão de utilizadores).
    // O fallback anónimo existe só para não rebentar se a rota for aberta sem
    // argumento — sem `id`, as ações de gestão ficam desativadas.
    _target = widget.user ??
        const AppUser(
          name: 'Utilizador',
          initials: 'U',
          role: UserRole.utilizador,
          course: '',
        );
    _role = _target.role;
  }

  bool get _canManage => _me.canManage(_target);

  /// Perfis que o gestor atual pode atribuir ao alvo.
  List<UserRole> get _assignableRoles {
    if (_me.isSuperAdmin) {
      // Super Admin pode atribuir qualquer perfil (até Super Admin).
      return UserRole.values;
    }
    if (_me.role == UserRole.admin) {
      // Admin promove no máximo até Admin, e nunca mexe noutro Admin/Super.
      return const [UserRole.utilizador, UserRole.escritor, UserRole.admin];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Gerir Perfil',
      showBack: true,
      children: [
        _header(context),
        const SizedBox(height: 16),
        _ruleBanner(context),
        const SizedBox(height: 24),
        const SectionTitle('Perfil de acesso'),
        const SizedBox(height: 6),
        Text(
          _canManage
              ? 'Selecione o perfil a atribuir. As permissões são cumulativas.'
              : 'Não tem autoridade para alterar este perfil.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: UserRole.values.map((r) {
            final active = r == _role;
            final allowed = _canManage && _assignableRoles.contains(r);
            return ChoiceChip(
              label: Text(r.label),
              selected: active,
              showCheckmark: false,
              onSelected: allowed ? (_) => setState(() => _role = r) : null,
              labelStyle: TextStyle(
                color: active ? Colors.white : (allowed ? AppColors.secondary : AppColors.outlineVariant),
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              side: BorderSide(color: active ? AppColors.primary : AppColors.outlineVariant),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const SectionTitle('O que este perfil pode fazer'),
        const SizedBox(height: 12),
        EhCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final p in _role.permissions)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 18, color: AppColors.success),
                      const SizedBox(width: 10),
                      Expanded(child: Text(p, style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_role == UserRole.superAdmin && _target.role != UserRole.superAdmin) ...[
          const SizedBox(height: 12),
          _superAdminNote(context),
        ],
        const SizedBox(height: 24),
        if (_canManage) ...[
          const SectionTitle('Ações'),
          const SizedBox(height: 12),
          EhButton(
            label: _saving ? 'A guardar...' : 'Guardar perfil',
            icon: Icons.save_outlined,
            onPressed: _saving ? null : _save,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _confirm(
              'Bloquear utilizador',
              'O utilizador deixa de poder aceder até ser desbloqueado.',
              'Bloquear',
              () => BackendService.instance.setUserActive(_target.id ?? '', false),
              '${_target.name} foi bloqueado.',
            ),
            icon: const Icon(Icons.block),
            label: const Text('Bloquear utilizador'),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.warning, side: const BorderSide(color: AppColors.warning), minimumSize: const Size.fromHeight(50)),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _target.isFounder
                ? null
                : () => _confirm(
                      'Remover utilizador',
                      'Esta ação é permanente e remove o acesso do utilizador.',
                      'Remover',
                      () => BackendService.instance.removeUser(_target.id ?? ''),
                      '${_target.name} foi removido.',
                    ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Remover utilizador'),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size.fromHeight(50)),
          ),
        ] else
          EhCard(
            color: AppColors.surfaceContainer,
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _target.isFounder
                        ? 'Este é o Super Admin fundador (grau 0) e não pode ser alterado.'
                        : 'Apenas um perfil de grau superior pode gerir este utilizador.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return EhCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.surfaceContainer,
            child: Text(_target.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(_target.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18))),
                    if (_target.isFounder) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.workspace_premium, size: 18, color: AppColors.warning),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(_target.email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                if (_target.isSuperAdmin)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Super Admin · grau ${_target.superAdminGrade}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navy.withValues(alpha: .2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.navy, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _me.isFounder
                  ? 'É o fundador (grau 0): pode gerir qualquer perfil.'
                  : _me.isSuperAdmin
                      ? 'Como Super Admin (grau ${_me.superAdminGrade}), só pode gerir Super Admins de grau maior e perfis inferiores.'
                      : 'Como Admin, gere apenas Utilizadores e Escritores.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _superAdminNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ao promover a Super Admin, este utilizador recebe o grau seguinte (inferior ao seu). '
              'Se o fundador sair, o Super Admin de grau imediatamente inferior assume o grau 0.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  bool _saving = false;

  /// Aplica a mudança de papel no backend (`PATCH /users/:id/role`). Sem `id`
  /// (utilizador mock) não há o que persistir.
  Future<void> _save() async {
    final id = _target.id;
    if (id == null || id.isEmpty) {
      _snack('Utilizador sem identificador — não é possível guardar.');
      return;
    }
    if (_role == _target.role) {
      Navigator.pop(context);
      return;
    }
    setState(() => _saving = true);
    try {
      await BackendService.instance.setUserRole(id, _role);
      if (!mounted) return;
      Navigator.pop(context);
      _snack('Perfil de ${_target.name} atualizado para ${_role.label}.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack('Não foi possível atualizar: $error');
    }
  }

  /// Executa uma ação destrutiva (bloquear/remover) após confirmação, chamando
  /// o backend. `perform` faz a chamada real; `successMsg` é a confirmação.
  void _confirm(
    String title,
    String message,
    String action,
    Future<void> Function() perform,
    String successMsg,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await perform();
                if (!mounted) return;
                Navigator.pop(context);
                _snack(successMsg);
              } catch (error) {
                if (!mounted) return;
                _snack('Não foi possível concluir: $error');
              }
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
