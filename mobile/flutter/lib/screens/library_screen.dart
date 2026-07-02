import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../services/feed_interactions.dart';
import '../services/feed_service.dart';
import '../widgets/app_header.dart';
import '../widgets/feed_post_tile.dart';
import '../widgets/filter_chips_row.dart';

/// Minha Biblioteca — o conteúdo é apresentado no mesmo formato de feed contínuo
/// da Home. O filtro "A ler" mostra os artigos em progresso com barra de
/// leitura e ação "Continuar".
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, this.initialFilter = 0});

  /// Separador aberto por omissão (0 = Tudo, 1 = A ler, 2 = Guardados,
  /// 3 = Offline). Permite abrir diretamente nos "Guardados" a partir do perfil.
  final int initialFilter;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late int _filter = widget.initialFilter;
  static const _filters = ['Tudo', 'A ler', 'Guardados', 'Offline'];

  final _store = FeedInteractions.instance;

  /// Conteúdo de aprendizagem (artigos, vídeos, podcasts, Jindungo).
  List<FeedContent> get _library => FeedService.instance.catalog
      .where((c) =>
          c.type == FeedContentType.article ||
          c.type == FeedContentType.jindungo ||
          c.type == FeedContentType.video ||
          c.type == FeedContentType.podcast)
      .toList();

  List<FeedEntry> _entries() {
    final fs = FeedService.instance;
    switch (_filter) {
      case 1: // A ler — em progresso
        return fs.continueReading();
      case 2: // Guardados
        return (_library.where((c) => _store.isSaved(c.id)).toList()
              ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt)))
            .map(fs.entryFor)
            .toList();
      case 3: // Offline (disponíveis sem ligação)
      case 0: // Tudo
      default:
        return (_library..sort((a, b) => b.publishedAt.compareTo(a.publishedAt))).map(fs.entryFor).toList();
    }
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
    final reading = _filter == 1;
    final width = MediaQuery.sizeOf(context).width;
    final itemCount = 2 + (entries.isEmpty ? 1 : entries.length); // filtros + conteúdo + rodapé

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppHeader(title: 'Minha Biblioteca', showBack: true, showNotifications: false),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _maxWidth(width)),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 4, bottom: 24, left: reading ? 16 : 0, right: reading ? 16 : 0),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(reading ? 0 : 16, 8, reading ? 0 : 16, 12),
                    child: FilterChipsRow(
                      labels: _filters,
                      selected: _filter,
                      onSelected: (i) => setState(() => _filter = i),
                    ),
                  );
                }
                if (index == itemCount - 1) return _footer(context);
                if (entries.isEmpty) return _empty(context);
                final entry = entries[index - 1];
                if (reading) return _continueCard(entry);
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
    );
  }

  /// Cartão "A ler" com barra de progresso e ação Continuar.
  Widget _continueCard(FeedEntry entry) {
    final c = entry.content;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _open(entry),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15.5, height: 1.25)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: c.readProgress,
                    minHeight: 7,
                    backgroundColor: AppColors.surfaceHighest,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Text('${c.percent}% concluído',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('Continuar',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.offlineMode),
          icon: const Icon(Icons.download_done),
          label: const Text('Gerir conteúdos offline'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final (icon, title, message) = switch (_filter) {
      1 => (Icons.auto_stories_outlined, 'Sem leituras em progresso', 'Comece a ler um artigo para o retomar aqui.'),
      2 => (Icons.bookmark_border, 'Nada guardado ainda', 'Guarde artigos para os ler mais tarde.'),
      _ => (Icons.library_books_outlined, 'Biblioteca vazia', 'Os seus conteúdos aparecerão aqui.'),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Column(children: [
          Icon(icon, size: 44, color: AppColors.outline),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ]),
      ),
    );
  }
}
