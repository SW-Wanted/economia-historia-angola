import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Seletor de comunidade para publicação de conteúdos.
///
/// Mostra as comunidades que o utilizador possui. Quando [communities] está
/// vazio, o seletor fica **inativo** (o utilizador não gere nenhuma comunidade),
/// mantendo-se visível mas desativado. Segue o Design System da aplicação.
class CommunityPicker extends StatelessWidget {
  const CommunityPicker({
    super.key,
    required this.communities,
    required this.value,
    required this.onChanged,
  });

  /// Comunidades disponíveis (as que o utilizador possui/gere).
  final List<String> communities;

  /// Comunidade selecionada; `null` = publicar publicamente (sem comunidade).
  final String? value;

  final ValueChanged<String?> onChanged;

  bool get _enabled => communities.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final label = !_enabled
        ? 'Sem comunidades disponíveis'
        : value ?? 'Seleciona uma comunidade';
    final muted = !_enabled || value == null;

    return Opacity(
      opacity: _enabled ? 1 : .6,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _enabled ? () => _openSelector(context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .6)),
            ),
            child: Row(children: [
              Icon(_enabled ? Icons.groups_outlined : Icons.group_off_outlined,
                  size: 20, color: _enabled ? AppColors.primary : AppColors.outline),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: muted ? AppColors.secondary : AppColors.text,
                        fontWeight: value != null ? FontWeight.w600 : FontWeight.w400)),
              ),
              Icon(Icons.unfold_more, size: 20, color: _enabled ? AppColors.secondary : AppColors.outline),
            ]),
          ),
        ),
      ),
    );
  }

  void _openSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: 12 + MediaQuery.viewPaddingOf(sheetContext).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(children: [
                Text('Publicar em', style: Theme.of(sheetContext).textTheme.titleLarge),
              ]),
            ),
            _option(sheetContext, null, 'Público (sem comunidade)', Icons.public),
            for (final c in communities) _option(sheetContext, c, c, Icons.groups_outlined),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, String? option, String label, IconData icon) {
    final selected = option == value;
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : AppColors.secondary),
      title: Text(label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.text)),
      trailing: selected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        onChanged(option);
        Navigator.pop(context);
      },
    );
  }
}
