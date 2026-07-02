import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Criação de uma nova comunidade. Dentro da comunidade poderão depois ser
/// criados tópicos de uma categoria específica.
class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  static const _categories = ['Economia', 'História', 'Comércio', 'Educação', 'Agricultura', 'Cultura'];

  final _name = TextEditingController();
  final _description = TextEditingController();
  String _category = 'Economia';
  bool _private = false;
  bool _argsApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsApplied) return;
    _argsApplied = true;
    // Pré-seleção de privacidade vinda do menu "Criar".
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['private'] is bool) _private = args['private'] as bool;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Indique um nome para a comunidade.'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comunidade "${_name.text.trim()}" criada com sucesso.'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: _private ? 'Criar Comunidade Privada' : 'Criar Comunidade Pública',
      showBack: true,
      children: [
        const SectionTitle('Detalhes da comunidade'),
        const SizedBox(height: 16),
        Text('Nome', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        TextField(controller: _name, decoration: const InputDecoration(hintText: 'Ex.: Núcleo de Economia Colonial')),
        const SizedBox(height: 16),
        Text('Descrição', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        TextField(controller: _description, maxLines: 4, decoration: const InputDecoration(hintText: 'Sobre o que é esta comunidade?')),
        const SizedBox(height: 16),
        Text('Categoria', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: _categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
          ),
          child: SwitchListTile(
            value: _private,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _private = v),
            title: const Text('Comunidade privada'),
            subtitle: Text(
              _private ? 'Entrada por convite e aprovação.' : 'Aberta a todos os utilizadores.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
            ),
          ),
        ),
        if (_private) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.invite),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Gerir convites'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
          ),
        ],
        const SizedBox(height: 24),
        EhButton(label: 'Criar comunidade', icon: Icons.groups_outlined, onPressed: _submit),
      ],
    );
  }
}
