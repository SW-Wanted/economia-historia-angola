import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../core/constants/app_colors.dart';
import '../core/permissions/app_permissions.dart';
import '../core/routes/app_routes.dart';
import '../models/article_draft.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/community_picker.dart';
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
  bool _exclusive = false;
  String _category = 'Artigo';
  _ContentType _type = _ContentType.texto;
  String? _community; // comunidade selecionada; null = público
  bool _argsApplied = false;

  /// Sala de discussão do conteúdo: pública por defeito. Se o dono a tornar
  /// privada, assume o papel de professor da turma.
  bool _privateRoom = false;

  // Campos capturados (para refletir o conteúdo após a criação).
  final _titleCtrl = TextEditingController();
  final _extraCtrl = TextEditingController(); // fonte / ligação / episódio
  final _bodyCtrl = TextEditingController(); // corpo / descrição / notas
  bool _publishing = false;
  String? _mediaUrl;
  String? _mediaName;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _extraCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsApplied) return;
    _argsApplied = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _type = switch (args['type']) {
        'video' => _ContentType.video,
        'podcast' => _ContentType.podcast,
        _ => _ContentType.texto,
      };
      if (args['jindungo'] == true) {
        _jindungo = true;
        _category = 'Jindungo';
      }
      _exclusive = args['exclusive'] == true;
    }
  }

  String get _typeLabel => switch (_type) {
        _ContentType.video => 'Vídeo',
        _ContentType.podcast => 'Podcast',
        _ContentType.texto => _jindungo ? 'Texto Jindungo' : _exclusive ? 'Conteúdo exclusivo' : 'Artigo',
      };

  String get _title => 'Novo $_typeLabel';

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;

    if (!user.canCreateContent) {
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
      title: _title,
      showBack: true,
      children: [
        const SectionTitle('Tipo de conteúdo'),
        const SizedBox(height: 12),
        Row(children: [
          _typeChip(context, _ContentType.texto, Icons.article_outlined, 'Texto'),
          const SizedBox(width: 10),
          _typeChip(context, _ContentType.video, Icons.videocam_outlined, 'Vídeo'),
          const SizedBox(width: 10),
          _typeChip(context, _ContentType.podcast, Icons.mic_none_outlined, 'Podcast'),
        ]),
        const SizedBox(height: 24),
        const SectionTitle('Detalhes'),
        const SizedBox(height: 12),
        _label(context, 'Título'),
        TextField(controller: _titleCtrl, decoration: const InputDecoration(hintText: 'Ex.: O ciclo do café em Angola')),
        const SizedBox(height: 14),
        _label(context, 'Categoria'),
        DropdownButtonFormField<String>(
          initialValue: _category,
          items: const ['Artigo', 'História económica', 'Agricultura', 'Jindungo']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() {
            _category = v ?? _category;
            _jindungo = _category == 'Jindungo';
          }),
        ),
        const SizedBox(height: 14),
        _label(context, 'Publicar em (opcional)'),
        CommunityPicker(
          communities: FeedService.instance.ownedCommunities,
          value: _community,
          onChanged: (v) => setState(() => _community = v),
        ),
        if (FeedService.instance.ownedCommunities.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 2),
            child: Text('Ainda não gere nenhuma comunidade onde publicar.',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ),
        const SizedBox(height: 14),
        ..._typeFields(context),
        const SizedBox(height: 24),

        // Sala de discussão — pública por defeito.
        const SectionTitle('Sala de discussão'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .5)),
          ),
          child: SwitchListTile(
            value: _privateRoom,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _privateRoom = v),
            title: const Text('Sala privada (turma)'),
            subtitle: Text(
              _privateRoom ? 'Reservada — assume o papel de professor da turma.' : 'Aberta a todos — discussão pública.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
            ),
          ),
        ),
        if (_privateRoom) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.invite),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Gerir estudantes'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
          ),
        ],
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
          label: _publishing ? 'A publicar...' : 'Pré-visualizar e publicar',
          icon: Icons.publish,
          onPressed: _publishing ? null : _preview,
        ),
      ],
    );
  }

  List<Widget> _typeFields(BuildContext context) {
    switch (_type) {
      case _ContentType.texto:
        return [
          _label(context, 'Bibliografia / fonte'),
          TextField(controller: _extraCtrl, decoration: const InputDecoration(hintText: 'Referência científica')),
          const SizedBox(height: 14),
          _label(context, 'Corpo do texto'),
          TextField(controller: _bodyCtrl, maxLines: 8, decoration: const InputDecoration(hintText: 'Escreva o conteúdo (1,5 a 2 páginas para artigos)...')),
        ];
      case _ContentType.video:
        return [
          _label(context, 'Ligação do vídeo (ou ficheiro)'),
          TextField(controller: _extraCtrl, decoration: const InputDecoration(hintText: 'URL ou carregar ficheiro de vídeo')),
          const SizedBox(height: 14),
          _uploadBox(context, Icons.videocam_outlined, 'Carregar vídeo', FileType.video),
          const SizedBox(height: 14),
          _label(context, 'Descrição'),
          TextField(controller: _bodyCtrl, maxLines: 4, decoration: const InputDecoration(hintText: 'Breve descrição do vídeo...')),
        ];
      case _ContentType.podcast:
        return [
          _label(context, 'Ficheiro de áudio'),
          _uploadBox(context, Icons.mic_none_outlined, 'Carregar áudio (MP3)', FileType.audio),
          const SizedBox(height: 14),
          _label(context, 'Episódio'),
          TextField(controller: _extraCtrl, decoration: const InputDecoration(hintText: 'Ex.: Episódio 4')),
          const SizedBox(height: 14),
          _label(context, 'Notas do episódio'),
          TextField(controller: _bodyCtrl, maxLines: 5, decoration: const InputDecoration(hintText: 'Resumo e tópicos abordados...')),
        ];
    }
  }

  /// Mostra uma pré-visualização que reflete tudo o que foi introduzido, antes
  /// de confirmar a publicação.
  void _preview() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Indique um título.')));
      return;
    }
    final extraLabel = switch (_type) {
      _ContentType.texto => 'Fonte',
      _ContentType.video => 'Ligação',
      _ContentType.podcast => 'Episódio',
    };

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: .78,
        minChildSize: .5,
        maxChildSize: .95,
        expand: false,
        builder: (context, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(children: [Text('Pré-visualização', style: Theme.of(context).textTheme.titleLarge)]),
            ),
            const Divider(height: 1, thickness: .6),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(99)),
                    child: Text('${_typeLabel.toUpperCase()} · ${_category.toUpperCase()}',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 11)),
                  ),
                  const SizedBox(height: 12),
                  Text(_titleCtrl.text.trim(), style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22, height: 1.2)),
                  const SizedBox(height: 14),
                  _pv('Publicar em', _community ?? 'Público (sem comunidade)'),
                  if (_extraCtrl.text.trim().isNotEmpty) _pv(extraLabel, _extraCtrl.text.trim()),
                  if (_mediaName != null) _pv('Ficheiro', _mediaName!),
                  _pv('Sala de discussão', _privateRoom ? 'Privada (turma) — professor' : 'Pública'),
                  _pv('Acesso', _jindungo ? 'Restrito (Jindungo)' : _exclusive ? 'Exclusivo' : 'Público'),
                  const SizedBox(height: 12),
                  if (_bodyCtrl.text.trim().isNotEmpty) ...[
                    Text('Conteúdo', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15, color: AppColors.primary)),
                    const SizedBox(height: 6),
                    Text(_bodyCtrl.text.trim(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.5)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 12 + MediaQuery.viewPaddingOf(sheetContext).bottom),
              child: EhButton(
                label: 'Confirmar publicação',
                icon: Icons.check_rounded,
                onPressed: () async {
                  Navigator.pop(sheetContext);
                  await _publish();
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _pv(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700))),
        ]),
      );

  Future<void> _pickAndUpload(FileType fileType) async {
    final result = await FilePicker.platform.pickFiles(type: fileType, withData: true);
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return;
    final mimeType = fileType == FileType.video ? _videoMime(file.name) : _audioMime(file.name);
    setState(() {
      _publishing = true;
      _mediaName = file.name;
    });
    try {
      final url = await BackendService.instance.uploadFile(
        bytes: bytes,
        filename: file.name,
        mimeType: mimeType,
      );
      if (!mounted) return;
      setState(() => _mediaUrl = url);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text('${file.name} carregado.')));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _mediaName = null;
        _mediaUrl = null;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      final type = switch (_type) {
        _ContentType.texto => 'ARTICLE',
        _ContentType.video => 'VIDEO',
        _ContentType.podcast => 'AUDIO',
      };
      final created = await BackendService.instance.createContent(
        title: _titleCtrl.text.trim(),
        type: type,
        summary: _bodyCtrl.text.trim(),
        body: _bodyCtrl.text,
        category: _category,
        sourceUrl: _type == _ContentType.video && _extraCtrl.text.trim().startsWith('http') ? _extraCtrl.text.trim() : null,
        mediaUrl: _mediaUrl,
        isJindungo: _jindungo,
        exclusive: _exclusive,
      );
      // Recarrega o catálogo para que o novo conteúdo apareça de imediato no
      // feed de todos os utilizadores (ao abrirem/atualizarem a Home).
      await FeedService.instance.load(force: true);
      if (!mounted) return;
      // Vídeo/podcast vão diretamente para o seu player real (reproduz o media
      // carregado); os restantes seguem para a leitura do artigo.
      if (_type == _ContentType.video) {
        Navigator.pushReplacementNamed(context, AppRoutes.videoPlayer, arguments: created);
      } else if (_type == _ContentType.podcast) {
        Navigator.pushReplacementNamed(context, AppRoutes.podcastPlayer, arguments: created);
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.reading,
          arguments: ArticleDraft(
            title: _titleCtrl.text.trim(),
            typeLabel: _typeLabel,
            category: _category,
            body: _bodyCtrl.text,
            source: _extraCtrl.text,
            community: _community,
            jindungo: _jindungo,
            exclusive: _exclusive,
            privateRoom: _privateRoom,
          ),
        );
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Conteúdo publicado para todos os utilizadores.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  String _videoMime(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.mov')) return 'video/quicktime';
    if (lower.endsWith('.webm')) return 'video/webm';
    if (lower.endsWith('.mkv')) return 'video/x-matroska';
    return 'video/mp4';
  }

  String _audioMime(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.wav')) return 'audio/wav';
    if (lower.endsWith('.m4a')) return 'audio/mp4';
    if (lower.endsWith('.ogg')) return 'audio/ogg';
    return 'audio/mpeg';
  }

  Widget _uploadBox(BuildContext context, IconData icon, String label, FileType fileType) => DottedUpload(
        icon: icon,
        label: _mediaName ?? label,
        uploaded: _mediaUrl != null,
        onTap: () => _pickAndUpload(fileType),
      );

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
          child: Column(children: [
            Icon(icon, color: active ? Colors.white : AppColors.primary),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: active ? Colors.white : AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
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
  const DottedUpload({super.key, required this.icon, required this.label, required this.onTap, this.uploaded = false});

  final IconData icon;
  final String label;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            Icon(uploaded ? Icons.check_circle_outline : icon, color: AppColors.primary, size: 30),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
