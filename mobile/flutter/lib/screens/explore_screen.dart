import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../services/feed_service.dart';
import '../widgets/angola_map.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/attention_pulse.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/feed_post_tile.dart';

/// Explorar — apresenta o conteúdo no mesmo formato de feed contínuo da Home
/// (publicações em largura total), mantendo a sua identidade: título, pesquisa
/// e filtros. A pesquisa e os filtros atuam diretamente sobre o feed.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  /// Categoria/ordenação — escolha única.
  int _category = 0;

  /// Tipos de conteúdo — multi-seleção (combinável com a categoria).
  final Set<FeedContentType> _types = {};

  late final Future<void> _catalogF = FeedService.instance.load();

  static const _categories = ['Todos', 'Virais', 'Novos', 'Do seu interesse', 'Sugeridos'];

  static const _typeChips = <(String, FeedContentType)>[
    ('Artigos', FeedContentType.article),
    ('Vídeos', FeedContentType.video),
    ('Podcasts', FeedContentType.podcast),
    ('Jindungo', FeedContentType.jindungo),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<FeedEntry> _entries() {
    final fs = FeedService.instance;
    var items = switch (_category) {
      1 => fs.exploreViral(),
      2 => fs.exploreNew(),
      3 => fs.exploreForYou(),
      4 => fs.exploreSuggested(),
      _ => fs.exploreAll(),
    };
    // Combina com os tipos selecionados (se nenhum, mostra todos).
    if (_types.isNotEmpty) items = items.where((c) => _types.contains(c.type)).toList();
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items.where((c) =>
          c.title.toLowerCase().contains(q) ||
          c.subtitle.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q) ||
          c.author.toLowerCase().contains(q)).toList();
    }
    return items.map(fs.entryFor).toList();
  }

  void _open(FeedEntry entry) {
    final route = entry.content.isRestricted ? AppRoutes.restrictedContent : entry.content.type.route;
    Navigator.pushNamed(context, route, arguments: entry.content);
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
      index: 1,
      // Símbolo do mapa em miniatura, flutuante — aparece/desaparece com o menu.
      floatingButton: _mapButton(context),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Explorar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800)),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth(width)),
              child: FutureBuilder<void>(
                future: _catalogF,
                builder: (context, snapshot) {
                  final loading = snapshot.connectionState != ConnectionState.done;
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 110),
                    itemCount: 1 + (loading || entries.isEmpty ? 1 : entries.length),
                    itemBuilder: (context, index) {
                      if (index == 0) return _filtersHeader(context);
                      if (loading) return _loading();
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------ Pesquisa + filtros

  Widget _filtersHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(context),
          const SizedBox(height: 14),
          // Categorias (escolha única).
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _pill(
                label: _categories[i],
                active: _category == i,
                onTap: () => setState(() => _category = i),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Tipos (multi-seleção, combináveis com a categoria).
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _typeChips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final (label, type) = _typeChips[i];
                final active = _types.contains(type);
                return _pill(
                  label: label,
                  active: active,
                  multi: true,
                  onTap: () => setState(() => active ? _types.remove(type) : _types.add(type)),
                );
              },
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
        hintText: 'Pesquisar história e economia...',
        prefixIcon: const AttentionPulse(child: Icon(Icons.search, color: AppColors.secondary)),
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

  /// Pílula de filtro. [multi] mostra um ✓ quando ativo (tipos combináveis).
  Widget _pill({required String label, required bool active, required VoidCallback onTap, bool multi = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: active ? AppColors.navy : AppColors.outlineVariant.withValues(alpha: .6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (multi && active) ...[
              const Icon(Icons.check, size: 15, color: Colors.white),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 14,
                    color: active ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Símbolo do mapa (miniatura) flutuante — abre o mapa interativo. Pulsa
  /// continuamente (heartbeat) enquanto se está no Explorar, atraindo a atenção.
  Widget _mapButton(BuildContext context) {
    return AttentionPulse(
      child: Tooltip(
        message: 'Explorar províncias',
        child: Material(
          color: AppColors.navy,
          shape: const CircleBorder(),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: .3),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pushNamed(context, AppRoutes.map),
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Padding(
                padding: EdgeInsets.all(13),
                child: AngolaMap(fill: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loading() => const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: AppLoadingIndicator(size: 72, showDots: false, message: 'A carregar conteúdos...')),
      );

  Widget _empty(BuildContext context) {
    // Distingue "sem conteúdos no backend" de "pesquisa/filtro sem resultados".
    final filtering = _query.trim().isNotEmpty || _types.isNotEmpty || _category != 0;
    final (icon, title, message) = filtering
        ? (Icons.search_off, 'Nada encontrado', 'Experimente outro termo ou filtro.')
        : (Icons.explore_off_outlined, 'Ainda não há conteúdos disponíveis',
            'Assim que forem publicados conteúdos, aparecerão aqui.');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Column(children: [
          Icon(icon, size: 44, color: AppColors.outline),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ]),
      ),
    );
  }
}
