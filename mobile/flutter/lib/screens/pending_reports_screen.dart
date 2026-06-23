import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/content_report.dart';
import '../services/mock_data_service.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';

/// Revisao de conteudo denunciado pela comunidade (moderacao).
class PendingReportsScreen extends StatefulWidget {
  const PendingReportsScreen({super.key});

  @override
  State<PendingReportsScreen> createState() => _PendingReportsScreenState();
}

class _PendingReportsScreenState extends State<PendingReportsScreen> {
  late final List<ContentReport> _reports = [...const MockDataService().reports()];

  void _resolve(int index, String message) {
    setState(() => _reports.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Denuncias Pendentes',
      showBack: true,
      children: [
        Text(
          _reports.isEmpty
              ? 'Sem denuncias pendentes.'
              : '${_reports.length} ${_reports.length == 1 ? 'denuncia aguarda' : 'denuncias aguardam'} revisao.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 16),
        if (_reports.isEmpty)
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
                  Text('Nao ha conteudo reportado por rever.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                ],
              ),
            ),
          ),
        for (var i = 0; i < _reports.length; i++) ...[
          _reportCard(context, i, _reports[i]),
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
              if (report.count > 1) _tag('${report.count} denuncias', AppColors.error),
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
                  onPressed: () => _resolve(index, 'Denuncia descartada. Conteudo mantido.'),
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
                  onPressed: () => _resolve(index, 'Conteudo removido.'),
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
