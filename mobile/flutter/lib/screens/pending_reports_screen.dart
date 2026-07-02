import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/content_report.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

/// Revisao de conteudo denunciado pela comunidade (moderacao).
class PendingReportsScreen extends StatefulWidget {
  const PendingReportsScreen({super.key});

  @override
  State<PendingReportsScreen> createState() => _PendingReportsScreenState();
}

class _PendingReportsScreenState extends State<PendingReportsScreen> {
  List<ContentReport>? _reports; // null enquanto carrega

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final reports = await BackendService.instance.reports();
    if (!mounted) return;
    setState(() => _reports = [...reports]);
  }

  Future<void> _resolve(int index, {required bool remove}) async {
    final list = _reports;
    if (list == null) return;
    final report = list[index];
    try {
      if (report.id != null) {
        await BackendService.instance.reviewReport(report.id!, remove: remove);
      }
    } catch (_) {
      // Sem ligação: resolve apenas localmente (otimista).
    }
    if (!mounted) return;
    setState(() => list.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(remove ? 'Conteúdo removido.' : 'Denúncia descartada. Conteúdo mantido.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reports = _reports;
    if (reports == null) {
      return const ScreenFrame(
        title: 'Denúncias Pendentes',
        showBack: true,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(child: AppLoadingIndicator(message: 'A carregar...')),
          ),
        ],
      );
    }
    return ScreenFrame(
      title: 'Denúncias Pendentes',
      showBack: true,
      children: [
        Text(
          reports.isEmpty
              ? 'Sem denúncias pendentes.'
              : '${reports.length} ${reports.length == 1 ? 'denúncia aguarda' : 'denúncias aguardam'} revisão.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 16),
        if (reports.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.verified_outlined, size: 56, color: AppColors.success),
                  const SizedBox(height: 12),
                  Text('Tudo revisto',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17)),
                  const SizedBox(height: 4),
                  Text('Não ha conteúdo reportado por rever.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                ],
              ),
            ),
          ),
        for (var i = 0; i < reports.length; i++) ...[
          _reportCard(context, i, reports[i]),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _reportCard(BuildContext context, int index, ContentReport report) {
    return EhCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(report.target.icon, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              _tag(report.target.label, AppColors.navy),
              const SizedBox(width: 6),
              if (report.count > 1) _tag('${report.count} denúncias', AppColors.error),
              const Spacer(),
              Text(report.timeAgo,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(report.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.flag_outlined, size: 16, color: AppColors.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(report.reason.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.error, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(report.excerpt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.4)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _resolve(index, remove: false),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Manter'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _resolve(index, remove: true),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Remover'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
    );
  }
}
