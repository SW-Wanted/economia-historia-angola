import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../widgets/content_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class ProvinceContentsScreen extends StatelessWidget {
  const ProvinceContentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const MockDataService().contents();
    return ScreenFrame(title: 'Conteudos por provincia', showBack: true, children: [
      const SectionTitle('Benguela'),
      const SizedBox(height: 14),
      const Text('Ferrovias, comercio regional e circulacao de mercadorias.'),
      const SizedBox(height: 20),
      for (final item in items.take(3)) ...[ContentCard(item: item), const SizedBox(height: 12)],
    ]);
  }
}
