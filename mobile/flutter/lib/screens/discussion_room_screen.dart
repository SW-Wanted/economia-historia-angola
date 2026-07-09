import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/utils/responsive.dart';
import '../models/discussion_room.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';

/// Sala de Discussão — espaço privado (comentários) de uma sala de estudo.
/// Recebe uma [DiscussionRoom] e liga-se ao backend real: mensagens,
/// envio e (para o professor) gestão de participantes.
class DiscussionRoomScreen extends StatefulWidget {
  const DiscussionRoomScreen({super.key, this.room});

  final DiscussionRoom? room;

  @override
  State<DiscussionRoomScreen> createState() => _DiscussionRoomScreenState();
}

class _DiscussionRoomScreenState extends State<DiscussionRoomScreen> {
  final _controller = TextEditingController();
  List<RoomMessage>? _messages;
  bool _sending = false;

  DiscussionRoom? get _room => widget.room;

  @override
  void initState() {
    super.initState();
    if (_room != null) _loadMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await BackendService.instance.roomMessages(_room!.id);
      if (!mounted) return;
      setState(() => _messages = messages);
    } catch (_) {
      if (!mounted) return;
      setState(() => _messages = const []);
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _room == null || _sending) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await BackendService.instance.sendRoomMessage(roomId: _room!.id, text: text);
      _controller.clear();
      FocusScope.of(context).unfocus();
      await _loadMessages();
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.toString()), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = _room;
    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sala de Discussão')),
        body: const Center(child: Text('Sala indisponível.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(room.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800)),
        actions: [
          if (room.isOwner)
            IconButton(
              tooltip: 'Gerir participantes',
              icon: const Icon(Icons.manage_accounts_outlined),
              onPressed: () => _manageSheet(context),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
            child: Column(
              children: [
                _privateBanner(context),
                Expanded(child: _messageList(context, room)),
                _composer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _privateBanner(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(AppSpacing.margin, 12, AppSpacing.margin, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.navy.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.navy.withValues(alpha: .25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.navy, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Espaço privado — apenas participantes veem esta sala.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.navy)),
            ),
          ],
        ),
      );

  Widget _messageList(BuildContext context, DiscussionRoom room) {
    final messages = _messages;
    if (messages == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: AppLoadingIndicator(message: 'A carregar mensagens...')),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 12, AppSpacing.margin, 12),
      children: [
        if (room.description.isNotEmpty) ...[
          Text(room.description, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
        ],
        if (messages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('Ainda não há mensagens. Comece a discussão.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ),
          )
        else
          for (final m in messages) ...[_messageTile(context, m), const SizedBox(height: 10)],
      ],
    );
  }

  Widget _messageTile(BuildContext context, RoomMessage m) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.author, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(m.text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
          ],
        ),
      );

  Widget _composer(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 10, AppSpacing.margin, 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Participar na discussão...'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Enviar mensagem',
              style: IconButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: _sending ? null : _send,
              icon: _sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      );

  Future<void> _manageSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _ParticipantsSheet(room: _room!),
    );
  }
}

/// Folha de gestão de participantes (só professor): lista, convida por email e remove.
class _ParticipantsSheet extends StatefulWidget {
  const _ParticipantsSheet({required this.room});

  final DiscussionRoom room;

  @override
  State<_ParticipantsSheet> createState() => _ParticipantsSheetState();
}

class _ParticipantsSheetState extends State<_ParticipantsSheet> {
  final _email = TextEditingController();
  List<RoomParticipant>? _participants;
  bool _inviting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final list = await BackendService.instance.roomParticipants(widget.room.id);
      if (!mounted) return;
      setState(() => _participants = list);
    } catch (_) {
      if (!mounted) return;
      setState(() => _participants = const []);
    }
  }

  Future<void> _invite() async {
    final email = _email.text.trim();
    if (email.isEmpty || _inviting) return;
    setState(() => _inviting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await BackendService.instance.inviteRoomParticipant(roomId: widget.room.id, email: email);
      _email.clear();
      await _load();
      messenger.showSnackBar(
        const SnackBar(content: Text('Participante adicionado.'), behavior: SnackBarBehavior.floating),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.toString()), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _inviting = false);
    }
  }

  Future<void> _remove(RoomParticipant p) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await BackendService.instance.removeRoomParticipant(roomId: widget.room.id, userId: p.userId);
      await _load();
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.toString()), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final participants = _participants;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Participantes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email do participante'),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _inviting ? null : _invite,
                child: Text(_inviting ? '...' : 'Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (participants == null)
            const Padding(padding: EdgeInsets.all(20), child: Center(child: AppLoadingIndicator()))
          else if (participants.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Text('Sem participantes.'))
          else
            ...participants.map((p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.surfaceContainer,
                    child: Text(_initials(p.name),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ),
                  title: Text(p.name),
                  // O backend impede remover o professor; nos restantes, permite.
                  trailing: IconButton(
                    tooltip: 'Remover',
                    icon: const Icon(Icons.person_remove_outlined, color: AppColors.error),
                    onPressed: () => _remove(p),
                  ),
                )),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}
