import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../services/feed_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/feed_post_tile.dart';

/// Fórum — os debates são apresentados no mesmo formato de feed contínuo da
/// Home (publicações em largura total), para se parecerem com os fóruns que já
/// aparecem no feed. A criação de fóruns é feita pelo botão "Criar".
class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  int _filter = 0;

  static const _filters = ['Todos', 'Públicos', 'Comunidades', 'Privados'];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<FeedEntry> _entries() {
    final fs = FeedService.instance;
    var items = fs.catalog.where((c) => c.type == FeedContentType.forum).toList();

    switch (_filter) {
      case 1: // Públicos (livres, sem comunidade)
        items = items.where((c) => c.community == null).toList();
      case 2: // Em comunidades (públicas)
        items = items.where((c) => c.community != null && !c.communityPrivate).toList();
      case 3: // Privados
        items = items.where((c) => c.communityPrivate).toList();
    }

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items.where((c) =>
          c.title.toLowerCase().contains(q) ||
          c.subtitle.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q) ||
          c.author.toLowerCase().contains(q) ||
          (c.community?.toLowerCase().contains(q) ?? false)).toList();
    }

    items = [...items]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return items.map(fs.entryFor).toList();
  }

  void _open(FeedEntry entry) {
    final route = entry.content.isRestricted ? AppRoutes.restrictedContent : entry.content.type.route;
    Navigator.pushNamed(context, route);
  }

  double _maxWidth(double w) {
    if (w >= 1100) return 720;
    if (w >= 700) return 640;
    return w;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries();
    final width = MediaQuery.sizeOf(context).width;

    return BottomNavShell(
      index: 2,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text('Fórum',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800)),
          titleSpacing: 20,
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth(width)),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110),
                itemCount: 1 + (entries.isEmpty ? 1 : entries.length),
                itemBuilder: (context, index) {
                  if (index == 0) return _header(context);
                  if (entries.isEmpty) return _empty(context);
                  final entry = entries[index - 1];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeedPostTile(entry: entry, onOpen: () => _open(entry)),
                      Container(height: 8, color: AppColors.background),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------- Cabeçalho + filtros

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _hero(context),
          const SizedBox(height: 16),
          _searchBar(context),
          const SizedBox(height: 14),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _chip(context, i),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, Color(0xFF002336)],
                ),
              ),
            ),
          ),
          Positioned(right: -10, top: -12, child: Icon(Icons.forum_rounded, size: 110, color: Colors.white.withValues(alpha: .08))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debata a economia de Angola',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 19)),
                const SizedBox(height: 6),
                Text('Participe nos debates da comunidade — toque para juntar-se.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return TextField(
      controller: _search,
      onChanged: (v) => setState(() => _query = v),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Pesquisar discussões',
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
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: .6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, int i) {
    final active = i == _filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: active ? AppColors.navy : AppColors.outlineVariant.withValues(alpha: .6)),
        ),
        child: Text(
          _filters[i],
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 14,
                color: active ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Column(children: [
          const Icon(Icons.forum_outlined, size: 44, color: AppColors.outline),
          const SizedBox(height: 12),
          Text('Sem debates por agora',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text('Use o botão "Criar" para abrir um novo fórum.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ]),
      ),
    );
  }
}
