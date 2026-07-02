import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.title = 'Economia com História',
    this.showBack = false,
    this.showNotifications = true,
  });

  final String title;
  final bool showBack;

  /// Esconder o sino de notificações (ex.: antes de autenticação).
  final bool showNotifications;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    // A seta de voltar e o atalho de início aparecem apenas quando o ecrã os
    // pede explicitamente (showBack). Nos ecrãs-raiz com barra de navegação
    // inferior (Início, Explorar, Fórum, Perfil) showBack é falso, pelo que
    // a barra superior fica limpa — sem botão de voltar nem de início.
    final back = showBack;

    return AppBar(
      leadingWidth: 60,
      leading: back
          ? IconButton(
              tooltip: 'Voltar',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back),
            )
          : null,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800)),
      actions: [
        // O sino de notificações só aparece nas páginas-raiz (sem botão de
        // voltar), onde faz sentido. Nas páginas secundárias o cabeçalho fica
        // limpo. O atalho de "início" foi removido por ser redundante com o
        // botão de voltar e a barra de navegação inferior.
        if (!back && showNotifications)
          IconButton(
            tooltip: 'Notificações',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
