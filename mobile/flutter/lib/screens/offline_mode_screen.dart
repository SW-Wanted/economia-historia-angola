import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/content_item.dart';
import '../services/backend_service.dart';
import '../widgets/data_loader.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  final Set<int> _downloaded = {0, 1};
  final Future<List<ContentItem>> _future = BackendService.instance.contents();

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Modo Offline',
      showBack: true,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: .08), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.wifi_off, color: AppColors.navy),
            const SizedBox(width: 12),
            Expanded(child: Text(
              'Os artigos guardados ficam disponíveis sem ligação à internet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy),
            )),
          ]),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Artigos'),
        const SizedBox(height: 12),
        DataLoader<List<ContentItem>>(
          future: _future,
          builder: (context, all) {
            final items = all.where((c) => !c.locked).toList();
            return Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  EhCard(
                    child: Row(
                      children: [
                        Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                          child: Icon(items[i].icon, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(items[i].title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                              Text('${items[i].minutes} min • ${items[i].category}',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(_downloaded.contains(i) ? Icons.download_done : Icons.download_outlined,
                              color: _downloaded.contains(i) ? AppColors.success : AppColors.primary),
                          onPressed: () => setState(() {
                            _downloaded.contains(i) ? _downloaded.remove(i) : _downloaded.add(i);
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
