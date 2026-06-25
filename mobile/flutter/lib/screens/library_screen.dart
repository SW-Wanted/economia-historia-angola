import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/content_item.dart';
import '../services/backend_service.dart';
import '../widgets/content_card.dart';
import '../widgets/data_loader.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/screen_frame.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _filter = 0;
  static const _filters = ['Tudo', 'A ler', 'Guardados', 'Offline'];
  final Future<List<ContentItem>> _future = BackendService.instance.contents();

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Minha Biblioteca',
      showBack: true,
      children: [
        FilterChipsRow(labels: _filters, selected: _filter, onSelected: (i) => setState(() => _filter = i)),
        const SizedBox(height: 16),
        DataLoader<List<ContentItem>>(
          future: _future,
          builder: (context, all) {
            final items = _filter == 2 ? <ContentItem>[] : all.where((c) => !c.locked).toList();
            if (items.isEmpty) {
              return const EmptyState(
                icon: Icons.bookmark_border,
                title: 'Nada guardado ainda',
                message: 'Guarde microtextos e artigos para os ler mais tarde, mesmo offline.',
              );
            }
            return Column(
              children: [
                for (final item in items) ...[
                  ContentCard(item: item, onTap: () => Navigator.pushNamed(context, AppRoutes.reading)),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.offlineMode),
                  icon: const Icon(Icons.download_done),
                  label: const Text('Gerir conteúdos offline'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
