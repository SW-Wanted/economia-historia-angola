import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/app_settings.dart';
import '../widgets/eh_card.dart';
import '../widgets/screen_frame.dart';
import '../widgets/section_title.dart';

/// Definições da conta: palavra-passe, preferências, aparência (modo escuro,
/// idioma) e privacidade (bloqueio de perfil, políticas). Reutiliza o Design
/// System; não altera a arquitetura.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _s = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Definições',
      showBack: true,
      showNotifications: false,
      children: [
        // ---- Conta ----
        const SectionTitle('Conta'),
        const SizedBox(height: 12),
        _tile(context, Icons.password_outlined, 'Atualizar palavra-passe',
            subtitle: 'Alterar a sua palavra-passe de acesso.',
            onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword)),
        const SizedBox(height: 24),

        // ---- Preferências ----
        const SectionTitle('Preferências'),
        const SizedBox(height: 12),
        _card(children: [
          _switch('Receber notificações', _s.notifications, (v) => setState(() => _s.notifications = v)),
          _divider(),
          _switch('Receber newsletters', _s.newsletters, (v) => setState(() => _s.newsletters = v)),
          _divider(),
          _switch('Mostrar estatísticas de leitura', _s.showReadingStats, (v) => setState(() => _s.showReadingStats = v)),
        ]),
        const SizedBox(height: 24),

        // ---- Aparência ----
        const SectionTitle('Aparência'),
        const SizedBox(height: 12),
        _card(children: [
          _switch('Modo escuro', _s.darkMode, (v) {
            setState(() => _s.darkMode = v);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(v ? 'Modo escuro ativado' : 'Modo escuro desativado'),
              ));
          }),
          _divider(),
          _navRow(Icons.language, 'Idioma', _s.language, _pickLanguage),
        ]),
        const SizedBox(height: 24),

        // ---- Privacidade ----
        const SectionTitle('Privacidade'),
        const SizedBox(height: 12),
        _card(children: [
          _switch('Bloqueio de perfil', _s.profileLocked, (v) => setState(() => _s.profileLocked = v),
              subtitle: 'Perfil visível apenas para administração.'),
          _divider(),
          _navRow(Icons.privacy_tip_outlined, 'Políticas de privacidade e uso', null, _showPolicies),
        ]),
        const SizedBox(height: 12),
      ],
    );
  }

  // ------------------------------------------------------------ componentes

  Widget _card({required List<Widget> children}) => EhCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(children: children),
      );

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged, {String? subtitle}) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
    );
  }

  Widget _navRow(IconData icon, String label, String? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          if (value != null)
            Text(value, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ]),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, {String? subtitle, required VoidCallback onTap}) {
    return EhCard(
      onTap: onTap,
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .10), borderRadius: BorderRadius.circular(11)),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
            if (subtitle != null)
              Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ]),
        ),
        const Icon(Icons.chevron_right, color: AppColors.outline),
      ]),
    );
  }

  Widget _divider() => Divider(height: 1, thickness: .6, color: AppColors.outlineVariant.withValues(alpha: .5));

  // --------------------------------------------------------------- ações

  void _pickLanguage() {
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
              child: Row(children: [Text('Idioma', style: Theme.of(context).textTheme.titleLarge)]),
            ),
            for (final lang in AppSettings.languages)
              ListTile(
                leading: Icon(lang == _s.language ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: lang == _s.language ? AppColors.primary : AppColors.outline),
                title: Text(lang),
                onTap: () {
                  setState(() => _s.language = lang);
                  Navigator.pop(sheetContext);
                },
              ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  void _showPolicies() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: .7,
        minChildSize: .5,
        maxChildSize: .92,
        expand: false,
        builder: (context, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(99))),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                child: Row(children: [
                  Text('Políticas de privacidade e uso', style: Theme.of(context).textTheme.titleLarge),
                ]),
              ),
              const Divider(height: 1, thickness: .6),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    _policy(context, 'Recolha de dados',
                        'Recolhemos apenas os dados necessários ao funcionamento educativo da plataforma (conta, progresso e interações).'),
                    _policy(context, 'Utilização',
                        'Os conteúdos destinam-se a fins educativos. É proibido o uso indevido, cópia não autorizada ou partilha de conteúdo restrito.'),
                    _policy(context, 'Privacidade',
                        'Pode bloquear a visibilidade do seu perfil nas Definições. Os seus dados não são vendidos a terceiros.'),
                    _policy(context, 'Comunidade',
                        'Espera-se respeito nas discussões. Conteúdos abusivos podem ser removidos pela moderação.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _policy(BuildContext context, String title, String body) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted, height: 1.45)),
        ]),
      );
}
