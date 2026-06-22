import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class PublishContentScreen extends StatefulWidget {
  const PublishContentScreen({super.key});

  @override
  State<PublishContentScreen> createState() => _PublishContentScreenState();
}

class _PublishContentScreenState extends State<PublishContentScreen> {
  bool _jindungo = false;
  String _category = 'Microtexto';

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Publicar Conteudo',
      showBack: true,
      children: [
        const SectionTitle('Novo conteudo'),
        const SizedBox(height: 16),
        _label(context, 'Titulo'),
        const TextField(decoration: InputDecoration(hintText: 'Ex.: O ciclo do cafe em Angola')),
        const SizedBox(height: 14),
        _label(context, 'Categoria'),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: const ['Microtexto', 'Historia economica', 'Agricultura', 'Jindungo']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() {
            _category = v ?? _category;
            _jindungo = _category == 'Jindungo';
          }),
        ),
        const SizedBox(height: 14),
        _label(context, 'Bibliografia / fonte'),
        const TextField(decoration: InputDecoration(hintText: 'Referencia cientifica')),
        const SizedBox(height: 14),
        _label(context, 'Corpo do texto'),
        const TextField(maxLines: 8, decoration: InputDecoration(hintText: 'Escreva o conteudo (1,5 a 2 paginas para microtextos)...')),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
          ),
          child: SwitchListTile(
            value: _jindungo,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _jindungo = v),
            title: const Text('Texto com Jindungo (acesso restrito)'),
            subtitle: Text('Requer permissao para leitura.',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ),
        ),
        const SizedBox(height: 24),
        EhButton(
          label: 'Publicar agora',
          icon: Icons.publish,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.publishConfirmation),
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 2),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
      );
}
