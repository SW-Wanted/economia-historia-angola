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
  const ProvinceContentsScreen({super.key});

  @override
  State<ProvinceContentsScreen> createState() => _ProvinceContentsScreenState();
}

class _ProvinceContentsScreenState extends State<ProvinceContentsScreen> {
  final Future<List<ContentItem>> _contentsF = BackendService.instance.contents();
  final Future<List<RankingUser>> _rankingF = BackendService.instance.ranking();

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Benguela', showBack: true, children: [
      // Cabeçalho ilustrado
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
            Text('Benguela', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 28)),
          ]),
        ),
      ]),
      const SizedBox(height: 20),

      // Indicadores económicos
      const SectionTitle('Indicadores económicos'),
      const SizedBox(height: 12),
      Row(children: const [
        Expanded(child: _Indicator(icon: Icons.pie_chart_outline, value: '9,8%', label: 'Peso na economia')),
        SizedBox(width: 12),
        Expanded(child: _Indicator(icon: Icons.directions_boat_outlined, value: 'Lobito', label: 'Porto principal')),
        SizedBox(width: 12),
        Expanded(child: _Indicator(icon: Icons.agriculture_outlined, value: 'Pesca', label: 'Setor-chave')),
      ]),
      const SizedBox(height: 24),

      // Dados históricos
      const SectionTitle('Marcos históricos'),
      const SizedBox(height: 12),
      _timeline(context, '1903', 'Início do Caminho de Ferro de Benguela.'),
      _timeline(context, '1929', 'Ligação ferroviária ao interior mineiro.'),
      _timeline(context, '1970', 'Auge das exportações pelo porto do Lobito.'),
      const SizedBox(height: 24),

      // Estatísticas regionais
      const SectionTitle('Estatísticas regionais'),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          _stat(context, 'Estudantes ativos', '312'),
          _stat(context, 'Conteúdos locais', '24'),
          _stat(context, 'Quizzes concluídos', '1.480'),
        ]),
      ),
      const SizedBox(height: 24),

      // Ranking local
      SectionTitle('Ranking local', action: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.ranking),
        child: const Text('Ver todo', style: TextStyle(color: AppColors.primary)),
      )),
      const SizedBox(height: 12),
      DataLoader<List<RankingUser>>(
        future: _rankingF,
        builder: (context, ranking) {
          final localRanking = ranking.where((u) => u.province == 'Benguela').toList()
            ..sort((a, b) => b.points.compareTo(a.points));
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
      const SizedBox(height: 12),

      // Conteúdos relacionados
      const SectionTitle('Conteúdos relacionados'),
      const SizedBox(height: 12),
      DataLoader<List<ContentItem>>(
        future: _contentsF,
        builder: (context, items) => Column(
          children: [
            for (final item in items.take(3)) ...[
              ContentCard(item: item, onTap: () => Navigator.pushNamed(context, AppRoutes.reading)),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    ]);
  }

  Widget _timeline(BuildContext context, String year, String text) {
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          Expanded(child: Container(width: 2, color: AppColors.outlineVariant)),
        ]),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(year, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 15)),
              const SizedBox(height: 2),
              Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _stat(BuildContext context, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted))),
          Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
        ]),
      );
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11)),
      ]),
    );
  }
}
