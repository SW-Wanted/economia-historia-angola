import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/feed.dart';
import '../services/backend_service.dart';
import '../services/feed_interactions.dart';
import 'comment_sheet.dart';
import 'eh_illustration.dart';

/// Publicação do feed em estilo rede social: largura total, sem cartões nem
/// sombras — a separação entre posts é feita por divisores subtis e espaço em
/// branco. Inclui cabeçalho do autor, capa full-bleed, métricas e barra de
/// ações (curtir, comentar, guardar, partilhar) com animações Material.
class FeedPostTile extends StatefulWidget {
  const FeedPostTile({super.key, required this.entry, required this.onOpen});

  final FeedEntry entry;
  final VoidCallback onOpen;

  @override
  State<FeedPostTile> createState() => _FeedPostTileState();
}

class _FeedPostTileState extends State<FeedPostTile> with TickerProviderStateMixin {
  final _store = FeedInteractions.instance;

  late final AnimationController _likePulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  late final AnimationController _burst =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 650));

  Timer? _viewTimer;

  FeedContent get _c => widget.entry.content;

  @override
  void initState() {
    super.initState();
    // Conta uma visualização após o post permanecer montado (≈ visível, pois o
    // ListView.builder só constrói itens perto da viewport) alguns segundos.
    _viewTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_store.markViewed(_c.id)) setState(() {});
    });
  }

  @override
  void dispose() {
    _viewTimer?.cancel();
    _likePulse.dispose();
    _burst.dispose();
    super.dispose();
  }

  /// Pulsa o ícone (cresce e volta ao normal).
  void _playPulse() => _likePulse.forward(from: 0).then((_) {
        if (mounted) _likePulse.reverse();
      });

  void _toggleLike() {
    final liked = _store.toggleLike(_c.id);
    if (liked) _playPulse();
    setState(() {});
  }

  void _doubleTapLike() {
    if (!_store.isLiked(_c.id)) {
      _store.toggleLike(_c.id);
      _playPulse();
    }
    _burst.forward(from: 0);
    setState(() {});
  }

  void _toggleSave() {
    final saved = _store.toggleSave(_c.id);
    setState(() {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text(saved ? 'Guardado na sua biblioteca' : 'Removido da biblioteca'),
      ));
  }

  void _openComments() => showCommentSheet(context, _c, onChanged: () {
        if (mounted) setState(() {});
      });

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context),
        _cover(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReasonLine(entry: widget.entry),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: widget.onOpen,
                child: Text(c.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 19, height: 1.25)),
              ),
              const SizedBox(height: 6),
              Text(c.subtitle,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.45)),
              const SizedBox(height: 10),
              Row(children: [
                Icon(c.type.icon, size: 15, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(_metaText(c),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.secondary, fontWeight: FontWeight.w600)),
              ]),
              if (c.isRestricted) _restrictedBanner(context) else _openButton(context),
              const SizedBox(height: 10),
              _stats(context),
            ],
          ),
        ),
        const Divider(height: 1, thickness: .6, indent: 12, endIndent: 12),
        _actionBar(context),
      ],
    );
  }

  // ------------------------------------------------------------------ Header

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 8),
      child: Row(
        children: [
          _avatar(),
          const SizedBox(width: 11),
          Expanded(child: _c.community != null ? _communityIdentity(context) : _authorIdentity(context)),
          _menu(context),
        ],
      ),
    );
  }

  Widget _avatar() {
    final c = _c;
    if (c.community != null) {
      // Avatar da comunidade (estilo Reddit).
      return CircleAvatar(
        radius: 21,
        backgroundColor: AppColors.navy.withValues(alpha: .12),
        child: const Icon(Icons.groups, color: AppColors.navy, size: 22),
      );
    }
    return CircleAvatar(
      radius: 21,
      backgroundColor: AppColors.surfaceContainer,
      child: Text(c.authorInitials,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }

  /// Cabeçalho quando o post pertence a uma comunidade: identidade `eh/…` em
  /// primeiro plano, autor por baixo — tal como no Reddit.
  Widget _communityIdentity(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Flexible(
            child: Text(c.communityHandle!,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15, color: AppColors.navy)),
          ),
          const SizedBox(width: 6),
          if (c.communityPrivate) _privateTag(context),
        ]),
        const SizedBox(height: 1),
        Text('por ${c.author} · ${relativePublished(c.publishedAt)} · ${c.type.label}',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
      ],
    );
  }

  Widget _authorIdentity(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(c.author,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
        const SizedBox(height: 1),
        Row(children: [
          Text(relativePublished(c.publishedAt),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
          const Text(' · ', style: TextStyle(color: AppColors.secondary, fontSize: 11.5)),
          Icon(c.type.icon, size: 12, color: AppColors.primary.withValues(alpha: .75)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(c.type.label,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11.5)),
          ),
        ]),
      ],
    );
  }

  /// Etiqueta "Privada" — deixa explícito que a comunidade é reservada.
  Widget _privateTag(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.navy.withValues(alpha: .30)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline, size: 11, color: AppColors.navy),
          SizedBox(width: 3),
          Text('Privada', style: TextStyle(color: AppColors.navy, fontSize: 10, fontWeight: FontWeight.w800)),
        ]),
      );

  /// Rótulo da linha de meta: adapta-se ao tipo (leitura, episódio, debate…).
  String _metaText(FeedContent c) {
    if (c.type.isForum) return '${c.type.label} · ${formatCount(_store.commentCount(c))} participações';
    if (c.type == FeedContentType.podcast) return '${c.type.label} · ${c.minutes} min de áudio';
    if (c.type == FeedContentType.video) return '${c.type.label} · ${c.minutes} min de vídeo';
    if (c.type == FeedContentType.quiz) return '${c.type.label} · ${c.minutes} min';
    return '${c.type.label} · ${c.minutes} min de leitura';
  }

  Widget _menu(BuildContext context) {
    // O autor/admin pode gerar um quiz a partir de conteúdo de aprendizagem
    // (artigo, vídeo ou podcast). Segue o modelo de permissões (canPublish).
    final canAuthor = BackendService.instance.cachedUser.canPublish && _c.type.canGenerateQuiz;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: AppColors.secondary),
      tooltip: 'Opções',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) {
        switch (value) {
          case 'save':
            _toggleSave();
          case 'quiz':
            _createQuiz();
          case 'hide':
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  behavior: SnackBarBehavior.floating, content: Text('Vamos mostrar menos conteúdos como este')));
          case 'report':
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  behavior: SnackBarBehavior.floating, content: Text('Obrigado. A denúncia foi enviada.')));
        }
      },
      itemBuilder: (context) => [
        // Guardar indisponível para conteúdo restrito (Jindungo/privado).
        if (!_c.isRestricted)
          _menuItem('save', _store.isSaved(_c.id) ? Icons.bookmark : Icons.bookmark_border,
              _store.isSaved(_c.id) ? 'Remover da biblioteca' : 'Guardar'),
        if (canAuthor) _menuItem('quiz', Icons.quiz_outlined, 'Criar quiz a partir deste'),
        _menuItem('hide', Icons.visibility_off_outlined, 'Não tenho interesse'),
        _menuItem('report', Icons.flag_outlined, 'Denunciar'),
      ],
    );
  }

  /// Abre a criação de quiz (com assistente de IA) a partir deste conteúdo.
  void _createQuiz() => Navigator.pushNamed(context, AppRoutes.createQuiz, arguments: _c);

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label) => PopupMenuItem(
        value: value,
        child: Row(children: [
          Icon(icon, size: 19, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text(label),
        ]),
      );

  // ------------------------------------------------------------------- Cover

  Widget _cover(BuildContext context) {
    final restricted = _c.isRestricted;
    return GestureDetector(
      onTap: widget.onOpen,
      // Conteúdo restrito não pode ser curtido por duplo toque (não há acesso).
      onDoubleTap: restricted ? null : _doubleTapLike,
      child: Stack(
        alignment: Alignment.center,
        children: [
          EhIllustration(scene: _c.scene, imageUrl: _c.imageUrl, height: 210, borderRadius: BorderRadius.zero),
          // Sem imagem própria do utilizador, mostra o símbolo do tipo (ex.:
          // microfone para podcast) para identificar o formato de imediato.
          _typeBadge(context),
          // Véu explícito de conteúdo restrito (Jindungo ou comunidade privada).
          if (restricted) _restrictedOverlay(context),
          // Coração da animação de duplo toque.
          ScaleTransition(
            scale: CurvedAnimation(parent: _burst, curve: Curves.elasticOut),
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(
                CurvedAnimation(parent: _burst, curve: const Interval(.5, 1, curve: Curves.easeOut)),
              ),
              child: _burst.isAnimating
                  ? Icon(Icons.favorite, color: Colors.white.withValues(alpha: .92), size: 96)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// Selo do tipo no canto da capa: ícone (ex.: microfone para podcast) + rótulo.
  /// Identifica o formato quando não há imagem própria do utilizador.
  Widget _typeBadge(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_c.type.icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            Text(_c.type.label,
                style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  /// Camada explícita sobre a capa de conteúdo reservado.
  Widget _restrictedOverlay(BuildContext context) {
    final private = _c.communityPrivate;
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: .55)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, color: Colors.white, size: 34),
            const SizedBox(height: 8),
            Text(private ? 'Conteúdo restrito' : 'Conteúdo exclusivo',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                private ? 'Apenas membros aprovados podem aceder' : 'Apenas membros autorizados podem aceder',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: .85), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Aviso explícito, por baixo do conteúdo, com o motivo da restrição e a ação
  /// para obter acesso.
  Widget _restrictedBanner(BuildContext context) {
    final c = _c;
    final private = c.communityPrivate;
    final message = private
        ? 'Publicado em ${c.communityHandle}, uma comunidade privada. Apenas membros aprovados podem ler e comentar.'
        : 'Texto com Jindungo — conteúdo exclusivo. Apenas membros autorizados podem aceder.';
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(private ? Icons.lock_outline : Icons.local_fire_department, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted, height: 1.35)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: FilledButton.icon(
                    onPressed: widget.onOpen,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                    ),
                    icon: Icon(private ? Icons.key_outlined : Icons.lock_open_rounded, size: 15),
                    label: Text(private ? 'Pedir acesso' : 'Desbloquear'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Botão de ação principal, específico do tipo: "Ler artigo", "Assistir
  /// vídeo", "Ouvir áudio"…
  Widget _openButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: widget.onOpen,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: .10),
            foregroundColor: AppColors.primary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
          ),
          icon: Icon(_c.type.icon, size: 18),
          label: Text(_c.type.action),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------- Stats

  Widget _stats(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 12.5);
    return Row(children: [
      Icon(Icons.visibility_outlined, size: 15, color: AppColors.outline),
      const SizedBox(width: 5),
      Text('${formatCount(_store.viewCount(_c))} visualizações', style: style),
      const Spacer(),
      Icon(Icons.favorite, size: 14, color: AppColors.primary.withValues(alpha: .8)),
      const SizedBox(width: 4),
      Text(formatCount(_store.likeCount(_c)), style: style),
      const SizedBox(width: 14),
      Text('${formatCount(_store.commentCount(_c))} comentários', style: style),
    ]);
  }

  // -------------------------------------------------------------- Action bar

  Widget _actionBar(BuildContext context) {
    // Conteúdo restrito (Jindungo/comunidade privada) não pode ser curtido,
    // comentado nem guardado a partir do feed — só após obter acesso.
    if (_c.isRestricted) return _lockedActionBar(context);

    final liked = _store.isLiked(_c.id);
    final saved = _store.isSaved(_c.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: ScaleTransition(
              scale: Tween<double>(begin: 1, end: 1.28).animate(
                CurvedAnimation(parent: _likePulse, curve: Curves.easeOut, reverseCurve: Curves.easeIn),
              ),
              child: _ActionButton(
                icon: liked ? Icons.favorite : Icons.favorite_border,
                label: 'Curtir',
                active: liked,
                onTap: _toggleLike,
              ),
            ),
          ),
          Expanded(child: _ActionButton(icon: Icons.mode_comment_outlined, label: 'Comentar', onTap: _openComments)),
          Expanded(
            child: _ActionButton(
              icon: saved ? Icons.bookmark : Icons.bookmark_border,
              label: 'Guardar',
              active: saved,
              onTap: _toggleSave,
            ),
          ),
        ],
      ),
    );
  }

  /// Barra de ações para conteúdo restrito: sem curtir/comentar/guardar. Toca
  /// para seguir ao ecrã de acesso/desbloqueio.
  Widget _lockedActionBar(BuildContext context) {
    return InkWell(
      onTap: widget.onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 17, color: AppColors.secondary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _c.communityPrivate
                    ? 'Interações disponíveis após entrar na comunidade'
                    : 'Curtir, comentar e guardar disponível após desbloquear',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Selo subtil que explica o porquê da recomendação, sobre fundo claro.
class _ReasonLine extends StatelessWidget {
  const _ReasonLine({required this.entry});
  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = entry.reason.color;
    return Row(children: [
      Icon(entry.reason.icon, size: 13, color: color),
      const SizedBox(width: 5),
      Flexible(
        child: Text(entry.reasonLabel,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: .2)),
      ),
    ]);
  }
}

/// Botão da barra de ações: ícone + texto, com ripple e realce quando ativo.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap, this.active = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.secondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 7),
            Text(label,
                style: TextStyle(color: color, fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
