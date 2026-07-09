import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../models/discussion_room.dart';
import '../services/backend_service.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/eh_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Lista as **salas privadas** do utilizador (onde é professor ou participante)
/// e permite criar uma nova sala.
class PrivateRoomsScreen extends StatefulWidget {
  const PrivateRoomsScreen({super.key});

  @override
  State<PrivateRoomsScreen> createState() => _PrivateRoomsScreenState();
}

class _PrivateRoomsScreenState extends State<PrivateRoomsScreen> {
  List<DiscussionRoom>? _rooms;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rooms = await BackendService.instance.rooms();
      if (!mounted) return;
      setState(() => _rooms = rooms);
    } catch (_) {
      if (!mounted) return;
      setState(() => _rooms = const []);
    }
  }

  Future<void> _createRoom() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova sala privada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Nome da sala'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: 'Descrição (opcional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              try {
                await BackendService.instance.createRoom(
                  name: nameController.text,
                  description: descController.text,
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (error) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(error.toString()), behavior: SnackBarBehavior.floating),
                  );
                }
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
    nameController.dispose();
    descController.dispose();
    if (created == true) _load();
  }

  Future<void> _openRoom(DiscussionRoom room) async {
    await Navigator.pushNamed(context, AppRoutes.discussionRoom, arguments: room);
    _load(); // atualiza contagens ao voltar
  }

  @override
  Widget build(BuildContext context) {
    final rooms = _rooms;
    return ScreenFrame(
      title: 'Salas Privadas',
      showBack: true,
      children: [
        SectionTitle(
          'As minhas salas',
          action: TextButton.icon(
            onPressed: _createRoom,
            icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
            label: const Text('Criar', style: TextStyle(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: 12),
        if (rooms == null)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: AppLoadingIndicator(message: 'A carregar salas...')),
          )
        else if (rooms.isEmpty)
          const EmptyState(
            icon: Icons.lock_person_outlined,
            title: 'Sem salas privadas',
            message: 'Crie uma sala para estudar em grupo ou aguarde ser adicionado a uma.',
          )
        else
          for (final room in rooms) ...[
            _roomTile(context, room),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  Widget _roomTile(BuildContext context, DiscussionRoom room) {
    return EhCard(
      onTap: () => _openRoom(room),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.forum_outlined, color: AppColors.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(room.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16))),
                    if (room.isOwner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                        child: Text('PROFESSOR',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ],
                ),
                if (room.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(room.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                ],
                const SizedBox(height: 6),
                Text('${room.participants} participantes • ${room.messages} mensagens',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
