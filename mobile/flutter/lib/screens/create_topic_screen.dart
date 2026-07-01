import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/feed_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  bool _private = false;
  String _category = 'Economia';
  bool _argsApplied = false;

  // Artigo em debate (opcional).
  bool _attachArticle = false;
  String? _article;

  List<String> get _articles => FeedService.instance.articleTitles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsApplied) return;
    _argsApplied = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['private'] is bool) _private = args['private'] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: _private ? 'Criar Sala Privada' : 'Criar Fórum',
      showBack: true,
      children: [
        const SectionTitle('Detalhes do tópico'),
        const SizedBox(height: 16),
        Text('Titulo', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        const TextField(decoration: InputDecoration(hintText: 'Ex.: O papel do café na economia colonial')),
        const SizedBox(height: 16),
        Text('Categoria', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: const ['Economia', 'História', 'Comercio', 'Educacao', 'Ancestralidade']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: 16),
        Text('Conteúdo', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        const TextField(maxLines: 6, decoration: InputDecoration(hintText: 'Apresente o tema para debate...')),
        const SizedBox(height: 20),
        // Artigo em debate (opcional): permite colocar um artigo em discussão.
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                value: _attachArticle,
                activeThumbColor: AppColors.primary,
                onChanged: _articles.isEmpty
                    ? null
                    : (v) => setState(() {
                          _attachArticle = v;
                          if (v) _article ??= _articles.first;
                        }),
                title: const Text('Colocar um artigo em debate'),
                subtitle: Text(
                  _articles.isEmpty
                      ? 'Não tem artigos para associar.'
                      : _attachArticle
                          ? 'O fórum ficará associado ao artigo escolhido.'
                          : 'Opcional — associe um artigo a este fórum.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
                ),
              ),
              if (_attachArticle && _articles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: DropdownButtonFormField<String>(
                    initialValue: _article,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Artigo em debate'),
                    items: _articles
                        .map((a) => DropdownMenuItem(
                            value: a, child: Text(a, maxLines: 1, overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: (v) => setState(() => _article = v),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                value: _private,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _private = v),
                title: const Text('Tópico privado'),
                subtitle: Text(
                  _private ? 'Entrada por convite e aprovação da administração.' : 'Visivel e aberto a todos os utilizadores.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
                ),
              ),
            ],
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
        EhButton(
          label: 'Publicar tópico',
          icon: Icons.send,
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.forum);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tópico publicado com sucesso'), behavior: SnackBarBehavior.floating),
            );
          },
        ),
      ],
    );
  }
}
