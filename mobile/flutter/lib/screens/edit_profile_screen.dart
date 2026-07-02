import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/backend_service.dart';
import '../services/feed_service.dart';
import '../widgets/eh_card.dart';

/// Edição de perfil redesenhada: capa, foto, e secções organizadas
/// (Informações, Áreas de Interesse, Redes Sociais, Preferências e, para
/// escritores, Perfil de Escritor). Interface limpa e profissional, preservando
/// o Design System. Não altera a lógica de negócio.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Informações pessoais.
  final _name = TextEditingController();
  final _bio = TextEditingController();
  final _location = TextEditingController();
  final _website = TextEditingController();

  // Perfil de escritor.
  final _specialty = TextEditingController();
  final _institution = TextEditingController();
  final _education = TextEditingController();
  final _proBio = TextEditingController();
  final _languages = TextEditingController();
  final _proWebsite = TextEditingController();
  final _publications = TextEditingController();

  // Áreas de interesse.
  late final Set<String> _interests = {...FeedService.instance.favoriteCategories};
  late final List<String> _allCategories =
      (FeedService.instance.catalog.map((c) => c.category).toSet().toList()..sort());

  // Redes sociais (até 5).
  final List<_Social> _socials = [];
  static const _maxSocials = 5;

  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    final user = BackendService.instance.cachedUser;
    _name.text = user.name;
    _location.text = user.province;
    for (final c in _controllers) {
      c.addListener(_markDirty);
    }
  }

  List<TextEditingController> get _controllers => [
        _name, _bio, _location, _website,
        _specialty, _institution, _education, _proBio, _languages, _proWebsite, _publications,
      ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final s in _socials) {
      s.controller.dispose();
    }
    super.dispose();
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  String? get _nameError => _name.text.trim().isEmpty ? 'O nome é obrigatório.' : null;

  bool _validUrl(String v) => v.trim().isEmpty || RegExp(r'^https?://').hasMatch(v.trim());

  bool get _canSave => _dirty && _nameError == null && _validUrl(_website.text);

  void _save() {
    if (!_canSave) return;
    // Persiste os interesses escolhidos (mesma fonte usada no feed).
    FeedService.instance.favoriteCategories = _interests.toList();
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Perfil atualizado'), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    final user = BackendService.instance.cachedUser;
    final isWriter = user.canPublish;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Fechar',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.close, color: AppColors.text),
        ),
        centerTitle: true,
        title: Text('Editar Perfil',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _canSave ? _save : null,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  color: _canSave ? AppColors.primary : AppColors.outline,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
                child: const Text('Guardar'),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _coverAndPhoto(context, user.initials),
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _personalInfo(context),
                    const SizedBox(height: 16),
                    _interestsSection(context),
                    const SizedBox(height: 16),
                    _socialsSection(context),
                    if (isWriter) ...[
                      const SizedBox(height: 16),
                      _writerSection(context),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------- Capa + Fotografia

  Widget _coverAndPhoto(BuildContext context, String initials) {
    return SizedBox(
      height: 130 + 56, // capa + metade da foto que sobressai
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Capa (placeholder elegante).
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                  ),
                ),
                Positioned(
                  right: -18, top: -14,
                  child: Icon(Icons.history_edu, size: 130, color: Colors.white.withValues(alpha: .10)),
                ),
                Positioned(
                  right: 12, top: 12,
                  child: _iconButtonChip(Icons.photo_camera_outlined, 'Alterar capa', () => _pick('capa')),
                ),
              ],
            ),
          ),
          // Fotografia sobreposta.
          Positioned(
            left: 20,
            top: 130 - 46,
            child: _BounceTap(
              onTap: () => _pick('fotografia'),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.primary,
                      child: Text(initials,
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  Positioned(
                    right: 0, bottom: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButtonChip(IconData icon, String label, VoidCallback onTap) {
    return _BounceTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .28),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  void _pick(String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, content: Text('Alterar $what')));
  }

  // -------------------------------------------------- Informações pessoais

  Widget _personalInfo(BuildContext context) {
    return _sectionCard(
      context,
      title: 'Informações Pessoais',
      children: [
        _field(context, 'Nome de exibição',
            controller: _name,
            hint: 'O seu nome',
            helper: 'Este nome será apresentado aos restantes utilizadores.',
            errorText: _dirty ? _nameError : null),
        _field(context, 'Biografia',
            controller: _bio,
            hint: 'Escreva uma breve apresentação sobre si.',
            maxLines: 4,
            maxLength: 200),
        _field(context, 'Localização (opcional)', controller: _location, hint: 'Ex.: Luanda, Angola'),
        _field(context, 'Website ou Portefólio (opcional)',
            controller: _website,
            hint: 'https://…',
            keyboardType: TextInputType.url,
            errorText: _validUrl(_website.text) ? null : 'Comece por http:// ou https://'),
      ],
    );
  }

  // -------------------------------------------------------- Interesses

  Widget _interestsSection(BuildContext context) {
    return _sectionCard(
      context,
      title: 'Áreas de Interesse',
      subtitle: 'As categorias que escolheu — usadas para personalizar o seu feed.',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in _interests) _interestChip(context, c),
            _addChip(context, 'Adicionar', _openInterestPicker),
          ],
        ),
      ],
    );
  }

  Widget _interestChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 6, top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.primary.withValues(alpha: .30)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => setState(() {
            _interests.remove(label);
            _markDirty();
          }),
          child: const Icon(Icons.close, size: 15, color: AppColors.primary),
        ),
      ]),
    );
  }

  Widget _addChip(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .8)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.add, size: 15, color: AppColors.navy),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ),
    );
  }

  void _openInterestPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheet) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(bottom: 16 + MediaQuery.viewPaddingOf(sheetContext).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99))),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                child: Row(children: [Text('Áreas de Interesse', style: Theme.of(context).textTheme.titleLarge)]),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in _allCategories)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _interests.contains(c) ? _interests.remove(c) : _interests.add(c);
                              _markDirty();
                            });
                            setSheet(() {});
                          },
                          child: _selectableChip(c, _interests.contains(c)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectableChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.navy : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: active ? AppColors.navy : AppColors.outlineVariant.withValues(alpha: .6)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (active) ...[const Icon(Icons.check, size: 15, color: Colors.white), const SizedBox(width: 5)],
        Text(label,
            style: TextStyle(color: active ? Colors.white : AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
      ]),
    );
  }

  // -------------------------------------------------------- Redes sociais

  Widget _socialsSection(BuildContext context) {
    final available = _Net.values.where((n) => !_socials.any((s) => s.net == n)).toList();
    return _sectionCard(
      context,
      title: 'Redes Sociais',
      subtitle: 'Partilhe os seus perfis para facilitar a ligação com outros membros da comunidade.',
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              for (var i = 0; i < _socials.length; i++) _socialRow(context, i),
            ],
          ),
        ),
        if (_socials.length < _maxSocials && available.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addSocial(available),
              icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
              label: const Text('Adicionar rede', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _socialRow(BuildContext context, int i) {
    final s = _socials[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(s.net.icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: s.controller,
              keyboardType: TextInputType.url,
              onChanged: (_) => _markDirty(),
              decoration: InputDecoration(hintText: s.net.hint, isDense: true),
            ),
          ),
          IconButton(
            tooltip: 'Remover',
            onPressed: () => setState(() {
              _socials.removeAt(i).controller.dispose();
              _markDirty();
            }),
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  void _addSocial(List<_Net> available) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: 12 + MediaQuery.viewPaddingOf(sheetContext).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(children: [Text('Adicionar rede', style: Theme.of(context).textTheme.titleLarge)]),
            ),
            for (final n in available)
              ListTile(
                leading: Icon(n.icon, color: AppColors.primary),
                title: Text(n.label),
                onTap: () {
                  Navigator.pop(sheetContext);
                  setState(() {
                    _socials.add(_Social(n));
                    _markDirty();
                  });
                },
              ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------- Perfil de escritor

  Widget _writerSection(BuildContext context) {
    return _sectionCard(
      context,
      title: 'Perfil de Escritor',
      subtitle: 'Estes dados reforçam a sua credibilidade junto da comunidade.',
      children: [
        _field(context, 'Área de especialização', controller: _specialty, hint: 'Ex.: Economia colonial'),
        _field(context, 'Instituição', controller: _institution, hint: 'Ex.: ISPTEC'),
        _field(context, 'Formação académica', controller: _education, hint: 'Ex.: Mestrado em Economia'),
        _field(context, 'Biografia profissional', controller: _proBio, hint: 'Percurso e áreas de investigação.', maxLines: 3, maxLength: 240),
        _field(context, 'Idiomas', controller: _languages, hint: 'Ex.: Português, Inglês'),
        _field(context, 'Website profissional', controller: _proWebsite, hint: 'https://…', keyboardType: TextInputType.url),
        _field(context, 'Ligações para publicações', controller: _publications, hint: 'URLs separados por vírgula', maxLines: 2),
      ],
    );
  }

  // ------------------------------------------------------------ utilitários

  Widget _sectionCard(BuildContext context, {required String title, String? subtitle, required List<Widget> children}) {
    return EhCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, height: 1.35)),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    BuildContext context,
    String label, {
    required TextEditingController controller,
    String? hint,
    String? helper,
    String? errorText,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 2),
            child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w700)),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            onChanged: (_) => setState(() {}), // validação em tempo real
            decoration: InputDecoration(
              hintText: hint,
              helperText: helper,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Redes sociais suportadas (ícone, rótulo e placeholder de URL).
enum _Net { linkedin, github, x, facebook, instagram, website }

extension _NetX on _Net {
  String get label => switch (this) {
        _Net.linkedin => 'LinkedIn',
        _Net.github => 'GitHub',
        _Net.x => 'X',
        _Net.facebook => 'Facebook',
        _Net.instagram => 'Instagram',
        _Net.website => 'Website',
      };

  IconData get icon => switch (this) {
        _Net.linkedin => Icons.business_center_outlined,
        _Net.github => Icons.code,
        _Net.x => Icons.alternate_email,
        _Net.facebook => Icons.facebook,
        _Net.instagram => Icons.camera_alt_outlined,
        _Net.website => Icons.language,
      };

  String get hint => switch (this) {
        _Net.linkedin => 'https://linkedin.com/in/…',
        _Net.github => 'https://github.com/…',
        _Net.x => 'https://x.com/…',
        _Net.facebook => 'https://facebook.com/…',
        _Net.instagram => 'https://instagram.com/…',
        _Net.website => 'https://…',
      };
}

class _Social {
  _Social(this.net);
  final _Net net;
  final TextEditingController controller = TextEditingController();
}

/// Pequena escala ao tocar (feedback subtil), para foto/capa e botões.
class _BounceTap extends StatefulWidget {
  const _BounceTap({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<_BounceTap> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
