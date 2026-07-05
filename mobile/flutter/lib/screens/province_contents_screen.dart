import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/content_item.dart';
import '../models/ranking_user.dart';
import '../services/backend_service.dart';
import '../widgets/content_card.dart';
import '../widgets/data_loader.dart';
import '../widgets/eh_illustration.dart';
import '../widgets/ranking_item.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class ProvinceContentsScreen extends StatefulWidget {
  const ProvinceContentsScreen({super.key, this.province});

  /// Nome da província clicada (ex.: "Benguela"). `null` se aberto sem contexto.
  final String? province;

  @override
  State<ProvinceContentsScreen> createState() => _ProvinceContentsScreenState();
}

class _ProvinceContentsScreenState extends State<ProvinceContentsScreen> {
  final Future<List<ContentItem>> _contentsF = BackendService.instance.contents();
  final Future<List<RankingUser>> _rankingF = BackendService.instance.ranking();

  String get _province => widget.province ?? 'Província';

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: _province, showBack: true, children: [
      // Cabeçalho ilustrado com o nome da província clicada.
      Stack(children: [
        EhIllustration(scene: EhScene.market, height: 150, borderRadius: BorderRadius.circular(20)),
        Positioned(
          left: 16, bottom: 14,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: const Text('PROVÍNCIA', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 11)),
            ),
            const SizedBox(height: 8),
            Text(_province, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 28)),
          ]),
        ),
      ]),
      const SizedBox(height: 24),

      // Ranking local — utilizadores desta província.
      SectionTitle('Ranking local', action: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.ranking),
        child: const Text('Ver todo', style: TextStyle(color: AppColors.primary)),
      )),
      const SizedBox(height: 12),
      DataLoader<List<RankingUser>>(
        future: _rankingF,
        builder: (context, ranking) {
          final localRanking = ranking.where((u) => u.province == _province).toList()
            ..sort((a, b) => b.points.compareTo(a.points));
          if (localRanking.isEmpty) return _emptyNotice('Ainda não há ranking disponível para esta província.');
          return Column(
            children: [
              for (var i = 0; i < localRanking.length && i < 3; i++) ...[
                RankingItem(user: localRanking[i], position: i + 1),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
      const SizedBox(height: 24),

      // Conteúdos relacionados — conteúdos desta província.
      const SectionTitle('Conteúdos relacionados'),
      const SizedBox(height: 12),
      DataLoader<List<ContentItem>>(
        future: _contentsF,
        builder: (context, items) {
          final related = items.where((c) => c.province == _province).take(3).toList();
          if (related.isEmpty) return _emptyNotice('Ainda não há conteúdos disponíveis para esta província.');
          return Column(
            children: [
              for (final item in related) ...[
                ContentCard(item: item, onTap: () => Navigator.pushNamed(context, AppRoutes.reading)),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    ]);
  }

  /// Aviso discreto quando uma secção não tem dados reais para mostrar.
  Widget _emptyNotice(String message) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          const Icon(Icons.inbox_outlined, color: AppColors.secondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: AppColors.secondary, height: 1.35)),
          ),
        ]),
      );
}
