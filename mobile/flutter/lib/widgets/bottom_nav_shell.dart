import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/constants/app_colors.dart';
import '../core/permissions/app_permissions.dart';
import '../core/routes/app_routes.dart';
import '../providers/app_state.dart';
import '../services/backend_service.dart';
import 'create_menu_sheet.dart';

/// Barra de navegação inferior flutuante (cápsula), com botão central
/// sobreposto e ocultação automática ao fazer scroll.
///
/// Substitui apenas a aparência/comportamento — a navegação e a lógica de
/// negócio mantêm-se: cada ícone abre a mesma rota de sempre.
class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key, required this.child, required this.index});

  final Widget child;
  final int index;

  static const _routes = [AppRoutes.dashboard, AppRoutes.explore, AppRoutes.forum, AppRoutes.profile];

  static const _items = [
    _NavItemData(Icons.home_outlined, Icons.home, 'Início'),
    _NavItemData(Icons.explore_outlined, Icons.explore, 'Explorar'),
    _NavItemData(Icons.forum_outlined, Icons.forum, 'Fórum'),
    _NavItemData(Icons.person_outline, Icons.person, 'Perfil'),
  ];

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  bool _visible = true;

  /// Mostra/esconde a barra conforme a direção do scroll vertical.
  /// Ignora scrolls horizontais (carrosséis) para não alternar a barra.
  bool _onScroll(UserScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n.direction == ScrollDirection.reverse && _visible) {
      setState(() => _visible = false);
    } else if (n.direction == ScrollDirection.forward && !_visible) {
      setState(() => _visible = true);
    }
    return false;
  }

  void _select(int i) {
    AppStateScope.of(context, listen: false).setNavIndex(i);
    if (i == widget.index) return;
    // O Perfil é aberto como página empilhada (com botão de voltar, sem menu);
    // os restantes separadores trocam entre si.
    if (BottomNavShell._routes[i] == AppRoutes.profile) {
      Navigator.pushNamed(context, AppRoutes.profile);
    } else {
      Navigator.pushReplacementNamed(context, BottomNavShell._routes[i]);
    }
  }

  /// Ação do botão "Criar", sensível ao contexto (separador atual):
  /// • Fórum → cria apenas fóruns;
  /// • Explorar → Centro de Criação, mas sem a opção de fórum;
  /// • restantes → Centro de Criação completo.
  void _onCreate() {
    final route = widget.index < BottomNavShell._routes.length
        ? BottomNavShell._routes[widget.index]
        : null;
    if (route == AppRoutes.forum) {
      Navigator.pushNamed(context, AppRoutes.createTopic);
    } else if (route == AppRoutes.explore) {
      showCreateMenu(context, excludeForum: true);
    } else {
      showCreateMenu(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Visibilidade do botão "Criar" controlada por permissões (não por papel).
    final canCreate = BackendService.instance.cachedUser.canCreateContent;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: NotificationListener<UserScrollNotification>(
              onNotification: _onScroll,
              child: widget.child,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !_visible,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                offset: _visible ? Offset.zero : const Offset(0, 1.6),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: _visible ? 1 : 0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset > 0 ? bottomInset : 14),
                    child: _bar(canCreate),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(bool canCreate) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cápsula flutuante.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: .14), blurRadius: 24, offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _navItem(0)),
                  Expanded(child: _navItem(1)),
                  if (canCreate) const SizedBox(width: 64),
                  Expanded(child: _navItem(2)),
                  Expanded(child: _navItem(3)),
                ],
              ),
            ),
          ),
          // Botão central sobreposto (criar conteúdo — escritores).
          if (canCreate)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: _CenterButton(
                  onTap: _onCreate,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(int i) {
    final item = BottomNavShell._items[i];
    final active = widget.index == i;
    return InkWell(
      onTap: () => _select(i),
      customBorder: const StadiumBorder(),
      child: SizedBox(
        height: 64,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(horizontal: active ? 16 : 10, vertical: 8),
            decoration: BoxDecoration(
              color: active ? AppColors.primary.withValues(alpha: .12) : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Icon(
              active ? item.selectedIcon : item.icon,
              color: active ? AppColors.primary : AppColors.secondary,
              size: 24,
              semanticLabel: item.label,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Botão central circular com animação de pressão (Material motion).
class _CenterButton extends StatefulWidget {
  const _CenterButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CenterButton> createState() => _CenterButtonState();
}

class _CenterButtonState extends State<_CenterButton> {
  bool _down = false;

  void _setDown(bool v) => setState(() => _down = v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setDown(true),
      onTapUp: (_) => _setDown(false),
      onTapCancel: () => _setDown(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.9 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            border: Border.all(color: AppColors.background, width: 4),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: .45), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
