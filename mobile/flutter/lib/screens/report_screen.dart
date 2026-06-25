import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

/// Sistema de denúncia de conteúdo inadequado.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _reason = -1;
  static const _reasons = [
    'Conteúdo ofensivo ou de ódio',
    'Informação falsa ou enganosa',
    'Spam ou publicidade',
    'Conteúdo partidário',
    'Outro motivo',
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Denunciar',
      showBack: true,
      children: [
        Text('Porque está a denunciar este conteúdo?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 6),
        Text('As denúncias são anónimas e revistas pela moderação.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 20),
        RadioGroup<int>(
          groupValue: _reason,
          onChanged: (v) => setState(() => _reason = v ?? -1),
          child: Column(
            children: [
              for (var i = 0; i < _reasons.length; i++)
                RadioListTile<int>(
                  value: i,
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: Text(_reasons[i]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Detalhes adicionais (opcional)')),
        const SizedBox(height: 24),
        EhButton(
          label: 'Enviar denúncia',
          icon: Icons.flag,
          onPressed: _reason == -1
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selecione um motivo'), behavior: SnackBarBehavior.floating))
              : () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Denúncia enviada. Obrigado.'), behavior: SnackBarBehavior.floating));
                },
        ),
      ],
    );
  }
}
