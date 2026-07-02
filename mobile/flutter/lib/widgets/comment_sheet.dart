import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/feed.dart';
import '../services/feed_interactions.dart';

/// Abre o Bottom Sheet moderno de comentários de uma publicação, sem sair do
/// feed. Devolve quando fechado; use [onChanged] para atualizar contadores.
Future<void> showCommentSheet(BuildContext context, FeedContent content, {VoidCallback? onChanged}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (_) => _CommentSheet(content: content),
  ).whenComplete(() => onChanged?.call());
}

class _CommentSheet extends StatefulWidget {
  const _CommentSheet({required this.content});
  final FeedContent content;

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final _store = FeedInteractions.instance;
  final _controller = TextEditingController();
  final _focus = FocusNode();
  FeedComment? _replyTo;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (_replyTo != null) {
        _store.addReply(widget.content, _replyTo!, text);
        _replyTo = null;
      } else {
        _store.addComment(widget.content, text);
      }
      _controller.clear();
    });
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final comments = _store.comments(widget.content);
    final count = _store.commentCount(widget.content);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: .72,
      minChildSize: .5,
      maxChildSize: .95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Puxador + cabeçalho.
              const SizedBox(height: 10),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
                child: Row(
                  children: [
                    Text('Comentários', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(formatCount(count),
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: .6),
              // Lista de comentários.
              Expanded(
                child: comments.isEmpty
                    ? _empty(context)
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        itemCount: comments.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 18),
                        itemBuilder: (context, i) => _CommentItem(
                          comment: comments[i],
                          onReply: () => _startReply(comments[i]),
                        ),
                      ),
              ),
              // Barra de escrita (responde ou comenta) — acompanha o teclado.
              _composer(context, bottomInset),
            ],
          ),
        );
      },
    );
  }

  void _startReply(FeedComment c) {
    setState(() => _replyTo = c);
    _focus.requestFocus();
  }

  Widget _empty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mode_comment_outlined, size: 40, color: AppColors.outline),
            const SizedBox(height: 10),
            Text('Ainda sem comentários.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
            Text('Seja o primeiro a comentar.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ],
        ),
      );

  Widget _composer(BuildContext context, double bottomInset) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.outlineVariant, width: .6)),
        ),
        padding: EdgeInsets.fromLTRB(14, 10, 10, 10 + MediaQuery.viewPaddingOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_replyTo != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.reply, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('A responder a ${_replyTo!.author}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _replyTo = null),
                      child: const Icon(Icons.close, size: 16, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.surfaceContainer,
                  child: Text('EU', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: _replyTo == null ? 'Escreva um comentário…' : 'Escreva a sua resposta…',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      filled: true,
                      fillColor: AppColors.surfaceLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentItem extends StatefulWidget {
  const _CommentItem({required this.comment, required this.onReply});
  final FeedComment comment;
  final VoidCallback onReply;

  @override
  State<_CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.comment;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bubble(context, c),
        for (final r in c.replies)
          Padding(
            padding: const EdgeInsets.only(left: 44, top: 14),
            child: _bubble(context, r, small: true),
          ),
      ],
    );
  }

  Widget _bubble(BuildContext context, FeedComment c, {bool small = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: small ? 14 : 17,
          backgroundColor: c.isMine ? AppColors.primary.withValues(alpha: .12) : AppColors.surfaceContainer,
          child: Text(c.initials,
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: small ? 10 : 12)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .45)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.author,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(c.text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35)),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(c.timeAgo, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Row(children: [
                      Icon(_liked ? Icons.favorite : Icons.favorite_border,
                          size: 14, color: _liked ? AppColors.primary : AppColors.secondary),
                      const SizedBox(width: 4),
                      Text('${c.likes + (_liked ? 1 : 0)}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontSize: 11.5)),
                    ]),
                  ),
                  if (!small) ...[
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: widget.onReply,
                      child: Text('Responder',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11.5)),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
