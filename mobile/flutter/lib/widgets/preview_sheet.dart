import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import 'eh_button.dart';

/// Um item de pré-visualização (título + pequena descrição).
class PreviewItem {
  const PreviewItem(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

/// Mostra uma **prévia** de alguns conteúdos a um visitante. Os primeiros itens
/// ficam visíveis; para aceder a tudo, o visitante é convidado a entrar/registar.
///
/// Se [previewRoute] for indicado, tocar num item **desbloqueado** abre esse
/// ecrã em modo prévia (`arguments: true`) — onde o próprio ecrã aplica os
/// limites (artigo parcial, vídeo/podcast até 30s, fórum sem comentários).
Future<void> showContentPreview(
  BuildContext context, {
  required String title,
  required IconData icon,
  required List<PreviewItem> items,
  String? previewRoute,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: .72,
      minChildSize: .5,
      maxChildSize: .95,
      expand: false,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Row(children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(99)),
                child: const Text('PRÉVIA', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 10)),
              ),
            ]),
          ),
          const Divider(height: 1, thickness: .6),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              children: [
                for (var i = 0; i < items.length; i++)
                  _previewCard(
                    context,
                    items[i],
                    locked: i >= 2,
                    onTap: (i >= 2 || previewRoute == null)
                        ? null
                        : () {
                            Navigator.pop(sheetContext);
                            Navigator.pushNamed(context, previewRoute, arguments: true);
                          },
                  ),
                const SizedBox(height: 8),
                _loginGate(context, sheetContext),
              ],
            ),
          ),
        ]),
      ),
    ),
  );
}

Widget _previewCard(BuildContext context, PreviewItem item, {required bool locked, VoidCallback? onTap}) {
  final card = Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
    ),
    child: Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.5)),
          const SizedBox(height: 2),
          Text(item.subtitle, maxLines: locked ? 1 : 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.3)),
        ]),
      ),
      if (locked)
        const Icon(Icons.lock_outline, color: AppColors.outline, size: 18)
      else if (onTap != null)
        const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
    ]),
  );
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: onTap == null
        ? card
        : Material(
            color: Colors.transparent,
            child: InkWell(borderRadius: BorderRadius.circular(14), onTap: onTap, child: card),
          ),
  );
}

Widget _loginGate(BuildContext context, BuildContext sheetContext) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.lock_open_outlined, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text('Aceda a todos os conteúdos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15))),
      ]),
      const SizedBox(height: 6),
      Text('Crie uma conta gratuita para ler, ouvir e participar por completo.',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.35)),
      const SizedBox(height: 14),
      EhButton(
        label: 'Criar conta',
        icon: Icons.arrow_forward,
        onPressed: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(context, AppRoutes.register1);
        },
      ),
      const SizedBox(height: 6),
      TextButton(
        onPressed: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(context, AppRoutes.login);
        },
        style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
        child: const Text('Já tenho conta — Entrar'),
      ),
    ]),
  );
}
