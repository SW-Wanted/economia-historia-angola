import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/content_item.dart';
import '../models/forum_topic.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/content_card.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/forum_topic_item.dart';
import '../widgets/screen_frame.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  int _filter = 0; // 0 Tudo, 1 Conteúdos, 2 Fórum
  String _query = '';
  bool _initialized = false;

  // Dados carregados do backend (com fallback) e filtrados localmente.
  List<ContentItem> _allContents = const [];
  List<ForumTopic> _allTopics = const [];
  bool _loaded = false;

  static const _filters = ['Tudo', 'Conteúdos', 'Fórum'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      BackendService.instance.contents(),
      BackendService.instance.forumTopics(),
    ]);
    if (!mounted) return;
    setState(() {
      _allContents = results[0] as List<ContentItem>;
      _allTopics = results[1] as List<ForumTopic>;
      _loaded = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String && arg.trim().isNotEmpty) {
        _controller.text = arg;
        _query = arg.toLowerCase();
      } else {
        // foca o campo para o utilizador começar a escrever
        WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool _matchContent(ContentItem c) {
    final q = _query;
    return c.title.toLowerCase().contains(q) ||
        c.subtitle.toLowerCase().contains(q) ||
        c.category.toLowerCase().contains(q) ||
        c.author.toLowerCase().contains(q);
  }

  bool _matchTopic(ForumTopic t) {
    final q = _query;
    return t.title.toLowerCase().contains(q) ||
        t.excerpt.toLowerCase().contains(q) ||
        t.tag.toLowerCase().contains(q) ||
        t.author.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.trim().isNotEmpty;

    final contents = hasQuery ? _allContents.where(_matchContent).toList() : <ContentItem>[];
    final topics = hasQuery ? _allTopics.where(_matchTopic).toList() : <ForumTopic>[];

    final showContents = _filter == 0 || _filter == 1;
    final showTopics = _filter == 0 || _filter == 2;
    final total = (showContents ? contents.length : 0) + (showTopics ? topics.length : 0);

    return ScreenFrame(title: 'Pesquisar', showBack: true, children: [
      TextField(
        controller: _controller,
        focusNode: _focus,
        textInputAction: TextInputAction.search,
        onChanged: (v) => setState(() => _query = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Pesquisar história, economia, autor...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpar pesquisa',
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _controller.clear();
                    _query = '';
                  }),
                ),
        ),
      ),
      const SizedBox(height: 14),
      FilterChipsRow(labels: _filters, selected: _filter, onSelected: (i) => setState(() => _filter = i)),
      const SizedBox(height: 18),

      if (!hasQuery)
        _hint(context)
      else if (!_loaded)
        const Padding(padding: EdgeInsets.only(top: 40), child: Center(child: AppLoadingIndicator(message: 'A pesquisar...')))
      else if (total == 0)
        _noResults(context)
      else ...[
        Text('$total resultado${total == 1 ? '' : 's'} para "${_controller.text}"',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
        const SizedBox(height: 14),
        if (showContents && contents.isNotEmpty) ...[
          Text('Conteúdos', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: 1)),
          const SizedBox(height: 10),
          for (final c in contents) ...[
            ContentCard(item: c, onTap: () => Navigator.pushNamed(context, c.locked ? AppRoutes.restrictedContent : AppRoutes.reading)),
            const SizedBox(height: 12),
          ],
        ],
        if (showTopics && topics.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text('Fórum', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: 1)),
          const SizedBox(height: 10),
          for (final t in topics) ...[
            ForumTopicItem(topic: t, onTap: () => Navigator.pushNamed(context, AppRoutes.forumTopic)),
            const SizedBox(height: 12),
          ],
        ],
      ],
    ]);
  }

  Widget _hint(BuildContext context) {
    final suggestions = ['Kwanza', 'Café', 'Benguela', 'Petróleo', 'Inflação'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sugestões de pesquisa', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in suggestions)
              ActionChip(
                label: Text(s),
                avatar: const Icon(Icons.north_east, size: 16, color: AppColors.primary),
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.outlineVariant),
                onPressed: () => setState(() {
                  _controller.text = s;
                  _query = s.toLowerCase();
                }),
              ),
          ],
        ),
      ],
    );
  }

  Widget _noResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(children: [
          const Icon(Icons.search_off, size: 56, color: AppColors.outline),
          const SizedBox(height: 12),
          Text('Sem resultados', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text('Tente outras palavras ou remova os filtros.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        ]),
      ),
    );
  }
}
