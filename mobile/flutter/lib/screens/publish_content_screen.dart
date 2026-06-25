import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/backend_service.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

enum _ContentType { texto, video, podcast }

class PublishContentScreen extends StatefulWidget {
  const PublishContentScreen({super.key});

  @override
  State<PublishContentScreen> createState() => _PublishContentScreenState();
}

class _PublishContentScreenState extends State<PublishContentScreen> {
  bool _jindungo = false;
  String _category = 'Microtexto';
  _ContentType _type = _ContentType.texto;

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;

    // Só Escritor ou superior pode publicar.
    if (!user.canPublish) {
      return ScreenFrame(
        title: 'Publicar Conteúdo',
        showBack: true,
        children: [
          const SizedBox(height: 40),
          const Center(child: Icon(Icons.lock_outline, size: 64, color: AppColors.primary)),
          const SizedBox(height: 16),
          Text('Acesso reservado', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
          const SizedBox(height: 8),
          Text(
            'A publicação de conteúdos está disponível para perfis de Escritor ou superior. '
            'Solicite a um Admin a promoção do seu perfil.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
          ),
        ],
      );
    }

    return ScreenFrame(
      title: 'Publicar Conteúdo',
      showBack: true,
      children: [
        const SectionTitle('Tipo de conteúdo'),
        const SizedBox(height: 12),
        Row(
          children: [
            _typeChip(context, _ContentType.texto, Icons.article_outlined, 'Texto'),
            const SizedBox(width: 10),
            _typeChip(context, _ContentType.video, Icons.videocam_outlined, 'Vídeo'),
            const SizedBox(width: 10),
            _typeChip(context, _ContentType.podcast, Icons.headphones_outlined, 'Podcast'),
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle('Detalhes'),
        const SizedBox(height: 12),
        _label(context, 'Título'),
        const TextField(decoration: InputDecoration(hintText: 'Ex.: O ciclo do café em Angola')),
        const SizedBox(height: 14),
        _label(context, 'Categoria'),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: const ['Microtexto', 'História económica', 'Agricultura', 'Jindungo']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() {
            _category = v ?? _category;
            _jindungo = _category == 'Jindungo';
          }),
        ),
        const SizedBox(height: 14),
        ..._typeFields(context),
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
            title: const Text('Conteúdo com Jindungo (acesso restrito)'),
            subtitle: Text('Requer permissão para aceder.',
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

  List<Widget> _typeFields(BuildContext context) {
    switch (_type) {
      case _ContentType.texto:
        return [
          _label(context, 'Bibliografia / fonte'),
          const TextField(decoration: InputDecoration(hintText: 'Referência científica')),
          const SizedBox(height: 14),
          _label(context, 'Corpo do texto'),
          const TextField(maxLines: 8, decoration: InputDecoration(hintText: 'Escreva o conteúdo (1,5 a 2 páginas para microtextos)...')),
        ];
      case _ContentType.video:
        return [
          _label(context, 'Ligação do vídeo (ou ficheiro)'),
          const TextField(decoration: InputDecoration(hintText: 'URL ou carregar ficheiro de vídeo')),
          const SizedBox(height: 14),
          _uploadBox(context, Icons.videocam_outlined, 'Carregar vídeo'),
          const SizedBox(height: 14),
          _label(context, 'Descrição'),
          const TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Breve descrição do vídeo...')),
        ];
      case _ContentType.podcast:
        return [
          _label(context, 'Ficheiro de áudio'),
          _uploadBox(context, Icons.audiotrack_outlined, 'Carregar áudio (MP3)'),
          const SizedBox(height: 14),
          _label(context, 'Episódio'),
          const TextField(decoration: InputDecoration(hintText: 'Ex.: Episódio 4')),
          const SizedBox(height: 14),
          _label(context, 'Notas do episódio'),
          const TextField(maxLines: 5, decoration: InputDecoration(hintText: 'Resumo e tópicos abordados...')),
        ];
    }
  }

  Widget _uploadBox(BuildContext context, IconData icon, String label) {
    return DottedUpload(icon: icon, label: label);
  }

  Widget _typeChip(BuildContext context, _ContentType type, IconData icon, String label) {
    final active = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? AppColors.primary : AppColors.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(icon, color: active ? Colors.white : AppColors.primary),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(color: active ? Colors.white : AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 2),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
      );
}

class DottedUpload extends StatelessWidget {
  const DottedUpload({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label (demonstração)'), behavior: SnackBarBehavior.floating),
      ),
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant, width: 1.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
