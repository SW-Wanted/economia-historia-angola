import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../widgets/content_card.dart';
import '../widgets/screen_frame.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const MockDataService().contents().take(2);
    return ScreenFrame(title: 'Minha Biblioteca', showBack: true, children: [
      for (final item in items) ...[ContentCard(item: item), const SizedBox(height: 12)],
    ]);
  }
}
