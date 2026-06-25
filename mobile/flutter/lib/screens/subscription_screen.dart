import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Estado simulado da subscrição (sem dependências externas, modo offline).
  bool _active = false;

  static const _benefits = [
    ('Textos com Jindungo', 'Análises críticas e aprofundadas sobre a economia angolana.'),
    ('Debates privados', 'Acesso ao Núcleo Jindungo e a fóruns reservados.'),
    ('Conteúdos regionais', 'Indicadores e estudos de caso por província.'),
    ('Leitura offline prioritária', 'Guarde os conteúdos exclusivos para ler sem ligação.'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Subscrição e Perfil', showBack: true, children: [
      // ---- Cabeçalho do plano ----
      EhCard(
        color: AppColors.primary,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.bolt, color: Colors.white),
            const SizedBox(width: 8),
            Text('Plano Jindungo',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
          ]),
          const SizedBox(height: 10),
          Text(
            'Aceda a conteúdos exclusivos sobre a história económica de Angola, '
            'debates privados e análises aprofundadas.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .88)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              _active ? 'Estado: Ativa' : 'Estado: Sem subscrição ativa',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 24),

      // ---- Benefícios ----
      const SectionTitle('Benefícios incluídos'),
      const SizedBox(height: 12),
      EhCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _benefits.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_benefits[i].$1,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(_benefits[i].$2,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
              if (i != _benefits.length - 1) const Divider(height: 24),
            ],
          ],
        ),
      ),
      const SizedBox(height: 24),

      // ---- Gestão da subscrição ----
      const SectionTitle('Gestão da subscrição'),
      const SizedBox(height: 12),
      EhCard(
        color: AppColors.surfaceLow,
        child: Row(children: [
          Icon(_active ? Icons.verified_outlined : Icons.lock_outline, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _active
                  ? 'A sua subscrição está ativa. Pode cancelar a qualquer momento.'
                  : 'Ative para desbloquear os conteúdos exclusivos. Projeto sem fins lucrativos.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 24),

      EhButton(
        label: _active ? 'Cancelar subscrição' : 'Ativar plano Jindungo',
        secondary: _active,
        onPressed: () {
          setState(() => _active = !_active);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_active ? 'Subscrição ativada' : 'Subscrição cancelada'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    ]);
  }
}
