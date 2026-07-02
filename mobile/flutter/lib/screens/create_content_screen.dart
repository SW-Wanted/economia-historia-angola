import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/permissions/app_permissions.dart';
import '../core/routes/app_routes.dart';
import '../services/backend_service.dart';

/// Uma opção de criação apresentada no Centro de Criação.
///
/// [requires] é a permissão necessária para a opção ser visível (RBAC). Uma
/// opção pode agrupar vários formatos que partilham o mesmo fluxo — é o caso de
/// "Conteúdo", que abre o ecrã de publicação (artigo, vídeo ou podcast).
class _CreateOption {
  const _CreateOption({
    required this.requires,
    required this.title,
    required this.description,
    required this.icon,
    required this.open,
  });

  final Permission requires;
  final String title;
  final String description;
  final IconData icon;
  final Future<void> Function(BuildContext context) open;
}

final List<_CreateOption> _options = [
  _CreateOption(
    requires: Permission.createArticle,
    title: 'Conteúdo',
    description: 'Escreva um artigo, grave um vídeo ou publique um podcast.',
    icon: Icons.post_add_outlined,
    open: (c) async {
      await Navigator.pushNamed(c, AppRoutes.publishContent);
    },
  ),
  _CreateOption(
    requires: Permission.createForum,
    title: 'Fórum',
    description: 'Crie um espaço de discussão.',
    icon: Icons.forum_outlined,
    open: (c) async {
      await Navigator.pushNamed(c, AppRoutes.createTopic);
    },
  ),
  _CreateOption(
    requires: Permission.createPublicCommunity,
    title: 'Comunidade',
    description: 'Crie uma comunidade para partilhar conhecimento.',
    icon: Icons.groups_outlined,
    open: (c) async {
      await Navigator.pushNamed(c, AppRoutes.createCommunity, arguments: {'private': false});
    },
  ),
  _CreateOption(
    requires: Permission.createJindungo,
    title: 'Texto Jindungo',
    description: 'Conteúdo exclusivo e restrito.',
    icon: Icons.local_fire_department_outlined,
    open: (c) async {
      await Navigator.pushNamed(c, AppRoutes.publishContent, arguments: {'type': 'texto', 'jindungo': true});
    },
  ),
  _CreateOption(
    requires: Permission.createExclusiveContent,
    title: 'Conteúdo exclusivo',
    description: 'Material premium para membros.',
    icon: Icons.workspace_premium_outlined,
    open: (c) async {
      await Navigator.pushNamed(c, AppRoutes.publishContent, arguments: {'type': 'texto', 'exclusive': true});
    },
  ),
];

/// "Centro de Criação de Conteúdos" — página aberta ao tocar no botão "Criar".
///
/// Opções construídas dinamicamente a partir das permissões do utilizador
/// (RBAC), com cartões modernos, pesquisa e grelha responsiva. Reutiliza o
/// Design System da aplicação; não altera permissões nem a lógica do FAB.
class CreateContentScreen extends StatefulWidget {
  const CreateContentScreen({super.key});

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  Permission? _selected;
  bool _excludeForum = false;
  bool _argsApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsApplied) return;
    _argsApplied = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['excludeForum'] == true) _excludeForum = true;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// Opções que o utilizador tem permissão de criar (respeitando o contexto,
  /// ex.: sem fórum quando aberto a partir do Explorar).
  List<_CreateOption> get _available => _options.where((o) {
        if (_excludeForum && o.requires == Permission.createForum) return false;
        return BackendService.instance.cachedUser.can(o.requires);
      }).toList();

  List<_CreateOption> get _filtered {
    if (_query.trim().isEmpty) return _available;
    final q = _query.trim().toLowerCase();
    return _available
        .where((o) => o.title.toLowerCase().contains(q) || o.description.toLowerCase().contains(q))
        .toList();
  }

  double _maxWidth(double w) {
    if (w >= 1100) return 920;
    if (w >= 700) return 680;
    return w;
  }

  int _columns(double w) {
    if (w >= 1100) return 4;
    if (w >= 700) return 3;
    return 2;
  }

  Future<void> _pick(_CreateOption o) async {
    setState(() => _selected = o.requires);
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (!mounted) return;
    await o.open(context);
    if (mounted) setState(() => _selected = null);
  }

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    final width = MediaQuery.sizeOf(context).width;

    // Utilizador sem permissões de criação nunca acede a esta página.
    if (!user.canCreateContent) return _reserved(context);

    final available = _available;
    final filtered = _filtered;
    final searching = _query.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _maxWidth(width)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, child) => Opacity(
                      opacity: t.clamp(0, 1),
                      child: Transform.translate(offset: Offset(0, (1 - t) * 14), child: child),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                      children: [
                        // Acesso rápido (scroll horizontal) — escondido ao pesquisar.
                        if (!searching) ...[
                          _sectionLabel(context, 'Acesso rápido'),
                          const SizedBox(height: 10),
                          _quickRow(context, available),
                          const SizedBox(height: 20),
                        ],
                        _searchBar(context),
                        const SizedBox(height: 18),
                        _sectionLabel(context, searching ? 'Resultados' : 'Todas as opções'),
                        const SizedBox(height: 12),
                        if (filtered.isEmpty)
                          _empty(context)
                        else
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: _columns(width),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 148,
                            children: [
                              for (final o in filtered)
                                _CreateCard(
                                  option: o,
                                  selected: _selected == o.requires,
                                  onTap: () => _pick(o),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ Header

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Fechar',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.close, color: AppColors.text),
          ),
          Expanded(
            child: Text('Criar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 17)),
          ),
          IconButton(
            tooltip: 'Notificações',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none, color: AppColors.text),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.secondary, fontWeight: FontWeight.w800, letterSpacing: .6, fontSize: 11),
      );

  // ------------------------------------------------------- Acesso rápido

  Widget _quickRow(BuildContext context, List<_CreateOption> items) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _QuickCard(option: items[i], onTap: () => _pick(items[i])),
      ),
    );
  }

  // -------------------------------------------------------------- Pesquisa

  Widget _searchBar(BuildContext context) {
    return TextField(
      controller: _search,
      onChanged: (v) => setState(() => _query = v),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'O que pretende criar?',
        prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, size: 18, color: AppColors.secondary),
                onPressed: () => setState(() {
                  _search.clear();
                  _query = '';
                }),
              ),
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: .6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(children: [
            const Icon(Icons.search_off, size: 40, color: AppColors.outline),
            const SizedBox(height: 10),
            Text('Nada encontrado para "${_query.trim()}"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          ]),
        ),
      );

  Widget _reserved(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.close, color: AppColors.text),
              ),
            ),
            const Spacer(),
            const Icon(Icons.lock_outline, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Acesso reservado', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
            const SizedBox(height: 8),
            Text('A criação de conteúdos está disponível para Escritores ou perfis superiores.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5)),
            const Spacer(flex: 2),
          ]),
        ),
      ),
    );
  }
}

/// Cartão compacto de acesso rápido (scroll horizontal).
class _QuickCard extends StatefulWidget {
  const _QuickCard({required this.option, required this.onTap});
  final _CreateOption option;
  final VoidCallback onTap;

  @override
  State<_QuickCard> createState() => _QuickCardState();
}

class _QuickCardState extends State<_QuickCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? .96 : 1,
      duration: const Duration(milliseconds: 120),
      child: SizedBox(
        width: 104,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .10), borderRadius: BorderRadius.circular(11)),
                    child: Icon(widget.option.icon, color: AppColors.primary, size: 20),
                  ),
                  Text(widget.option.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 13.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cartão detalhado da grelha, com hover (Web), escala ao toque e realce quando
/// selecionado.
class _CreateCard extends StatefulWidget {
  const _CreateCard({required this.option, required this.selected, required this.onTap});
  final _CreateOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<_CreateCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.option;
    final active = widget.selected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _pressed ? .97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: active ? AppColors.primary.withValues(alpha: .06) : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : _hover
                      ? AppColors.primary.withValues(alpha: .35)
                      : AppColors.outlineVariant.withValues(alpha: .5),
              width: active ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hover ? .08 : .03),
                blurRadius: _hover ? 14 : 8,
                offset: Offset(0, _hover ? 8 : 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: widget.onTap,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(o.icon, color: AppColors.primary, size: 22),
                    ),
                    const Spacer(),
                    Text(o.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(o.description,
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.3)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
