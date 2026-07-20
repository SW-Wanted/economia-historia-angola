import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/backend_service.dart';
import '../widgets/screen_frame.dart';

/// Gestão de acessos de um texto Jindungo: quem já tem acesso, convidar mais
/// pessoas por email e revogar acessos. Aberto a partir da gestão de conteúdos
/// (para o autor) ou da moderação.
class JindungoInviteesScreen extends StatefulWidget {
  const JindungoInviteesScreen({super.key, required this.contentId, required this.title});

  final String contentId;
  final String title;

  @override
  State<JindungoInviteesScreen> createState() => _JindungoInviteesScreenState();
}

class _JindungoInviteesScreenState extends State<JindungoInviteesScreen> {
  final _inviteCtrl = TextEditingController();
  List<Map<String, dynamic>>? _invitees; // null enquanto carrega
  bool _inviting = false;
  final Set<String> _revoking = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _inviteCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = await BackendService.instance.contentInvitees(widget.contentId);
    if (!mounted) return;
    setState(() => _invitees = list);
  }

  List<String> _parseEmails(String raw) => raw
      .split(RegExp(r'[,;\s]+'))
      .map((e) => e.trim().toLowerCase())
      .where((e) => e.contains('@'))
      .toSet()
      .toList();

  Future<void> _invite() async {
    final emails = _parseEmails(_inviteCtrl.text);
    if (emails.isEmpty) {
      _snack('Indique pelo menos um email válido.');
      return;
    }
    setState(() => _inviting = true);
    try {
      final r = await BackendService.instance.inviteToJindungo(widget.contentId, emails);
      _inviteCtrl.clear();
      await _load();
      if (!mounted) return;
      final parts = <String>[];
      if (r.invited.isNotEmpty) parts.add('${r.invited.length} convidado(s)');
      if (r.alreadyHad.isNotEmpty) parts.add('${r.alreadyHad.length} já tinha(m)');
      if (r.notFound.isNotEmpty) parts.add('sem conta: ${r.notFound.join(', ')}');
      _snack(parts.isEmpty ? 'Nada a convidar.' : parts.join(' · '));
    } catch (error) {
      if (!mounted) return;
      _snack('Não foi possível convidar: $error');
    } finally {
      if (mounted) setState(() => _inviting = false);
    }
  }

  Future<void> _revoke(Map<String, dynamic> item) async {
    final user = item['user'];
    final userId = user is Map ? user['id']?.toString() ?? '' : '';
    if (userId.isEmpty || _revoking.contains(userId)) return;
    setState(() => _revoking.add(userId));
    try {
      await BackendService.instance.revokeContentAccess(widget.contentId, userId);
      if (!mounted) return;
      setState(() => _invitees = _invitees?.where((i) {
            final u = i['user'];
            return !(u is Map && u['id']?.toString() == userId);
          }).toList());
    } catch (error) {
      if (!mounted) return;
      _snack('Não foi possível revogar: $error');
    } finally {
      if (mounted) setState(() => _revoking.remove(userId));
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invitees = _invitees;
    return ScreenFrame(
      title: 'Acessos ao texto',
      showBack: true,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17)),
        const SizedBox(height: 4),
        Text('Convide pessoas por email (recebem acesso imediato) e faça a gestão de quem pode ler.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 18),
        TextField(
          controller: _inviteCtrl,
          keyboardType: TextInputType.emailAddress,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Convidar por email',
            hintText: 'ana@exemplo.ao, joao@exemplo.ao',
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _inviting ? null : _invite,
            icon: _inviting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.person_add_alt),
            label: const Text('Convidar'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ),
        const SizedBox(height: 24),
        Text('Com acesso', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        if (invitees == null)
          const Padding(padding: EdgeInsets.only(top: 32), child: Center(child: CircularProgressIndicator()))
        else if (invitees.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text('Ainda ninguém tem acesso além de si.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
          )
        else
          for (final item in invitees) ...[
            _inviteeTile(context, item),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  Widget _inviteeTile(BuildContext context, Map<String, dynamic> item) {
    final user = item['user'];
    final name = user is Map ? user['name']?.toString() ?? 'Utilizador' : 'Utilizador';
    final email = user is Map ? user['email']?.toString() ?? '' : '';
    final userId = user is Map ? user['id']?.toString() ?? '' : '';
    final busy = _revoking.contains(userId);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surfaceContainer,
          child: Text(_initials(name), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
              if (email.isNotEmpty)
                Text(email, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
        busy
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(
                tooltip: 'Revogar acesso',
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                onPressed: () => _revoke(item),
              ),
      ]),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
