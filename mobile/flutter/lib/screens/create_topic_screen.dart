import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/feed_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Criação de um **fórum** (público ou privado). O criador é sempre o
/// **moderador** do fórum. Quando privado, pode gerir os convites.
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
      title: _private ? 'Fórum Privado' : 'Criar Fórum',
      showBack: true,
      showNotifications: false,
      children: [
        const SectionTitle('Detalhes do fórum'),
        const SizedBox(height: 16),
        _label(context, 'Título'),
        const TextField(decoration: InputDecoration(hintText: 'Ex.: O papel do café na economia colonial')),
        const SizedBox(height: 16),
        _label(context, 'Categoria'),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: const ['Economia', 'História', 'Comercio', 'Educacao', 'Ancestralidade']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: 16),
        _label(context, 'Conteúdo'),
        const TextField(maxLines: 6, decoration: InputDecoration(hintText: 'Apresente o tema para debate...')),
        const SizedBox(height: 20),

        _articleSection(context),
        const SizedBox(height: 16),

        _switchCard(
          title: 'Fórum privado',
          value: _private,
          onChanged: (v) => setState(() => _private = v),
          subtitle: _private ? 'Entrada por convite e aprovação.' : 'Visível e aberto a todos os utilizadores.',
        ),

        // O criador é sempre o moderador — em fóruns públicos ou privados.
        const SizedBox(height: 12),
        _roleNote(context, Icons.shield_outlined, 'Será o moderador deste fórum.',
            'Pode moderar comentários, bloquear tópicos e advertir participantes.'),

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
          label: 'Publicar fórum',
          icon: Icons.send,
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.forum);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fórum publicado com sucesso'), behavior: SnackBarBehavior.floating),
            );
          },
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
      );

  Widget _switchCard({required String title, required bool value, required ValueChanged<bool> onChanged, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
      ),
      child: SwitchListTile(
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
        title: Text(title),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
      ),
    );
  }

  Widget _roleNote(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
            Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.3)),
          ]),
        ),
      ]),
    );
  }

  Widget _articleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
      ),
      child: Column(children: [
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
                  .map((a) => DropdownMenuItem(value: a, child: Text(a, maxLines: 1, overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: (v) => setState(() => _article = v),
            ),
          ),
      ]),
    );
  }
}
