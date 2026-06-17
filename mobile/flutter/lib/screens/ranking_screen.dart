import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../services/mock_data_service.dart';
import '../widgets/ranking_item.dart';
import '../widgets/screen_frame.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ranking = const MockDataService().ranking();
    return ScreenFrame(title: 'Ranking', showBack: true, children: [
      Text('Liga Jindungo', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 18),
      for (var i = 0; i < ranking.length; i++) ...[
        RankingItem(user: ranking[i], position: i + 1, onTap: () => Navigator.pushNamed(context, AppRoutes.rankingDetail)),
        const SizedBox(height: 10),
      ],
    ]);
  }
}
