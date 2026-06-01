import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/bottom_nav_shell.dart';
import '../widgets/content_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const MockDataService().contents();
    return BottomNavShell(
      index: 1,
      child: ScreenFrame(title: 'Explorar', paddingBottom: 96, children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.searchResults),
          child: const AbsorbPointer(child: TextField(decoration: InputDecoration(hintText: 'Pesquisar conteudos', prefixIcon: Icon(Icons.search)))),
        ),
        const SizedBox(height: 20),
        Wrap(spacing: 8, runSpacing: 8, children: const [
          ChoiceChip(label: Text('Todos'), selected: true),
          ChoiceChip(label: Text('Microtextos'), selected: false),
          ChoiceChip(label: Text('Jindungo'), selected: false),
          ChoiceChip(label: Text('Provincias'), selected: false),
        ]),
        const SizedBox(height: 28),
        const SectionTitle('Conteudos em destaque'),
        const SizedBox(height: 14),
        for (final item in items) ...[
          ContentCard(item: item, onTap: () => Navigator.pushNamed(context, item.locked ? AppRoutes.restrictedContent : AppRoutes.reading)),
          const SizedBox(height: 12),
        ],
      ]),
    );
  }
}
