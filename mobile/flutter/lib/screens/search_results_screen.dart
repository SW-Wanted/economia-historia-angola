import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../widgets/content_card.dart';
import '../widgets/screen_frame.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const MockDataService().contents();
    return ScreenFrame(title: 'Resultados', showBack: true, children: [
      const TextField(decoration: InputDecoration(hintText: 'Kwanza', prefixIcon: Icon(Icons.search))),
      const SizedBox(height: 18),
      Text('${items.length} resultados encontrados', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 14),
      for (final item in items) ...[ContentCard(item: item), const SizedBox(height: 12)],
    ]);
  }
}
