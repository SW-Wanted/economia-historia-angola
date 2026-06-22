import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/eh_card.dart';
import '../widgets/section_title.dart';

/// Convites por e-mail e por código de acesso (decisão do resumo de sala).
class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  static const _code = 'ECH-2026-JND';

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convidar membros'),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.secondary,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Por e-mail'), Tab(text: 'Por codigo')],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tab,
          children: [_emailTab(context), _codeTab(context)],
        ),
      ),
    );
  }

  Widget _emailTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionTitle('Convite por e-mail'),
        const SizedBox(height: 8),
        Text('O membro recebe um convite e entra apos aprovacao do professor.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(hintText: 'nome@email.com', prefixIcon: Icon(Icons.mail_outline))),
        const SizedBox(height: 16),
        EhButton(
          label: 'Enviar convite',
          icon: Icons.send,
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Convite enviado'), behavior: SnackBarBehavior.floating),
          ),
        ),
        const SizedBox(height: 24),
        Text('Convites pendentes', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
        const SizedBox(height: 10),
        for (final e in const ['ana.muachia@isptec.co.ao', 'joao.d@isptec.co.ao'])
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: EhCard(
              child: Row(children: [
                const Icon(Icons.hourglass_empty, color: AppColors.secondary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(e, style: Theme.of(context).textTheme.bodyMedium)),
                Text('Pendente', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.warning)),
              ]),
            ),
          ),
      ],
    );
  }

  Widget _codeTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionTitle('Codigo de acesso'),
        const SizedBox(height: 8),
        Text('Partilhe este codigo. Quem o usar solicita entrada, sujeita a aprovacao.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            children: [
              Text('CODIGO DA CATEGORIA', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text(_code, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary, fontSize: 26, letterSpacing: 2)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Codigo copiado'), behavior: SnackBarBehavior.floating)),
            icon: const Icon(Icons.copy),
            label: const Text('Copiar'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
          )),
          const SizedBox(width: 12),
          Expanded(child: EhButton(label: 'Partilhar', icon: Icons.share, onPressed: () {})),
        ]),
      ],
    );
  }
}
