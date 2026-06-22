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
    'Conteudo ofensivo ou de odio',
    'Informacao falsa ou enganosa',
    'Spam ou publicidade',
    'Conteudo partidario',
    'Outro motivo',
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Denunciar',
      showBack: true,
      children: [
        Text('Porque esta a denunciar este conteudo?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 6),
        Text('As denuncias sao anonimas e revistas pela moderacao.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 20),
        for (var i = 0; i < _reasons.length; i++)
          RadioListTile<int>(
            value: i,
            groupValue: _reason,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: Text(_reasons[i]),
            onChanged: (v) => setState(() => _reason = v ?? -1),
          ),
        const SizedBox(height: 8),
        const TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Detalhes adicionais (opcional)')),
        const SizedBox(height: 24),
        EhButton(
          label: 'Enviar denuncia',
          icon: Icons.flag,
          onPressed: _reason == -1
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selecione um motivo'), behavior: SnackBarBehavior.floating))
              : () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Denuncia enviada. Obrigado.'), behavior: SnackBarBehavior.floating));
                },
        ),
      ],
    );
  }
}
