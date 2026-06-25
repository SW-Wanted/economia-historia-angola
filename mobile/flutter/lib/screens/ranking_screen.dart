import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/ranking_user.dart';
import '../services/backend_service.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/ranking_item.dart';
import '../widgets/screen_frame.dart';

enum _Scope { geral, provincia, instituicao }

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  _Scope _scope = _Scope.geral;
  List<RankingUser>? _all; // null enquanto carrega

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ranking = await BackendService.instance.ranking();
    if (!mounted) return;
    setState(() => _all = ranking);
  }

  @override
  Widget build(BuildContext context) {
    final me = BackendService.instance.cachedUser;
    final all = _all;
    if (all == null) {
      return const ScreenFrame(
        title: 'Ranking',
        showBack: true,
        children: [
          Padding(padding: EdgeInsets.only(top: 80), child: Center(child: CircularProgressIndicator())),
        ],
      );
    }

    // Filtra conforme o âmbito, relativo ao utilizador atual.
    // É criada sempre uma cópia mutável (.toList()) antes de ordenar, pois a
    // lista base de ranking() é const (imutável) e .sort() rebentaria com
    // "Unsupported operation: sort".
    final list = switch (_scope) {
      _Scope.geral => all.toList(),
      _Scope.provincia => all.where((u) => u.province == me.province).toList(),
      _Scope.instituicao => all.where((u) => u.institution == me.institution).toList(),
    }
      ..sort((a, b) => b.points.compareTo(a.points));

    final myIndex = list.indexWhere((u) => u.isCurrentUser);
    final scopeLabel = switch (_scope) {
      _Scope.geral => 'Angola',
      _Scope.provincia => me.province,
      _Scope.instituicao => me.institution,
    };

    return ScreenFrame(title: 'Ranking', showBack: true, children: [
      Text('Liga Jindungo', style: Theme.of(context).textTheme.displayLarge),
      const SizedBox(height: 4),
      Text('Veja a sua posição em diferentes contextos.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
      const SizedBox(height: 16),

      FilterChipsRow(
        labels: const ['Geral · Angola', 'Província', 'Instituição'],
        selected: _scope.index,
        onSelected: (i) => setState(() => _scope = _Scope.values[i]),
      ),
      const SizedBox(height: 16),

      // Cartão "a sua posição"
      if (myIndex >= 0) _myPositionCard(context, list[myIndex], myIndex + 1, scopeLabel),
      const SizedBox(height: 16),

      // Pódio + lista
      Text('Classificação · $scopeLabel', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
      const SizedBox(height: 12),
      if (list.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(
            child: Text('Ainda sem participantes neste contexto.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          ),
        ),
      for (var i = 0; i < list.length; i++) ...[
        RankingItem(
          user: list[i],
          position: i + 1,
          onTap: () => Navigator.pushNamed(context, AppRoutes.rankingDetail),
        ),
        const SizedBox(height: 10),
      ],
    ]);
  }

  Widget _myPositionCard(BuildContext context, RankingUser me, int pos, String scope) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A SUA POSIÇÃO', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70, letterSpacing: 1.2)),
              const SizedBox(height: 6),
              Text('#$pos', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 34)),
              Text('em $scope', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${me.points}', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 28)),
              Text('pontos', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: .2), borderRadius: BorderRadius.circular(99)),
                child: Text(me.level, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
