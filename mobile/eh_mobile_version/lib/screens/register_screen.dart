import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 1:
        return const _RegisterStep1();
      case 2:
        return const _RegisterStep2();
      case 3:
        return const _RegisterStep3();
      default:
        return const _RegisterStep1();
    }
  }
}

class _RegisterHeader extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  final IconData icon;

  const _RegisterHeader({required this.step, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Passo $step de 3', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: 1.5)),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: step / 3,
          backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.5),
          color: AppColors.primaryContainer,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        const SizedBox(height: 32),
        Text(title, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, color: AppColors.primaryContainer)),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
      ],
    );
  }
}

class _RegisterStep1 extends StatefulWidget {
  const _RegisterStep1();

  @override
  State<_RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<_RegisterStep1> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: Text('Economia com História', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryContainer, fontSize: 16)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RegisterHeader(step: 1, title: 'Criar conta', subtitle: 'Dados pessoais', icon: Icons.person),
            const SizedBox(height: 32),
            _buildTextField(context, 'Nome completo', 'Digite seu nome', false, null),
            const SizedBox(height: 16),
            _buildTextField(context, 'Email', 'exemplo@email.com', false, null),
            const SizedBox(height: 16),
            _buildTextField(context, 'Senha', '••••••••', true, _obscureText, () => setState(() => _obscureText = !_obscureText)),
            const SizedBox(height: 16),
            _buildTextField(context, 'Confirmar senha', '••••••••', true, _obscureConfirmText, () => setState(() => _obscureConfirmText = !_obscureConfirmText)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.register2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Continuar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Plus Jakarta Sans')),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: Text('Já tenho conta', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, String hint, bool isPassword, bool? obscure, [VoidCallback? onToggle]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ),
        TextField(
          obscureText: obscure ?? false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.outlineVariant),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            suffixIcon: isPassword ? IconButton(icon: Icon(obscure! ? Icons.visibility_off : Icons.visibility, color: AppColors.outline), onPressed: onToggle) : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ],
    );
  }
}

class _RegisterStep2 extends StatelessWidget {
  const _RegisterStep2();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: Text('Cadastro', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RegisterHeader(step: 2, title: 'Sobre você', subtitle: 'Ajude-nos a personalizar sua experiência acadêmica e profissional no portal.', icon: Icons.person),
            const SizedBox(height: 32),
            _buildFieldLabel(context, 'Instituição ou Escola'),
            _buildDropdown(context, 'Ex: Universidade Agostinho Neto'),
            const SizedBox(height: 16),
            _buildFieldLabel(context, 'Curso ou área'),
            _buildDropdown(context, 'Selecione sua área'),
            const SizedBox(height: 16),
            _buildFieldLabel(context, 'Nível académico'),
            _buildDropdown(context, 'Selecione seu nível'),
            const SizedBox(height: 16),
            _buildFieldLabel(context, 'Por que se interessa em Economia e História de Angola?'),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Compartilhe suas motivações acadêmicas...',
                hintStyle: TextStyle(color: AppColors.outlineVariant),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.bolt, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'O seu perfil nos ajuda a curar documentos históricos e análises econômicas específicas para sua área de atuação.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryContainer),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Voltar', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryContainer)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register3),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface)),
    );
  }

  Widget _buildDropdown(BuildContext context, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.outlineVariant)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: TextStyle(color: AppColors.outlineVariant, fontSize: 14)),
          const Icon(Icons.expand_more, color: AppColors.secondary),
        ],
      ),
    );
  }
}

class _RegisterStep3 extends StatefulWidget {
  const _RegisterStep3();

  @override
  State<_RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<_RegisterStep3> {
  int _selectedType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: Text('Cadastro', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RegisterHeader(step: 3, title: 'Tipo de acesso', subtitle: 'Selecione o plano que melhor se adapta aos seus estudos e pesquisas sobre a economia angolana.', icon: Icons.security),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => setState(() => _selectedType = 0),
              child: _buildAccessCard(context, 'Utilizador Livre', 'Acesso a artigos históricos básicos e fóruns públicos de discussão.', Icons.public, _selectedType == 0, false),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => _selectedType = 1),
              child: _buildAccessCard(context, 'Subscritor', 'Acesso ilimitado a análises profundas, dados históricos exclusivos e relatórios premium.', Icons.star, _selectedType == 1, true),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('"A compreensão do passado é o alicerce para a prosperidade económica do futuro angolano."', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.yellow, size: 20),
                      const SizedBox(width: 8),
                      Text('VISÃO HISTÓRICA', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9), letterSpacing: 1.5)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.quickStart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Finalizar cadastro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Ao finalizar, você concorda com nossos ',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary),
                  children: [
                    TextSpan(text: 'Termos de Uso', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessCard(BuildContext context, String title, String desc, IconData icon, bool isSelected, bool recommended) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primaryContainer : Colors.transparent, width: 2),
        boxShadow: [BoxShadow(color: const Color(0x0D000000), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (recommended)
            Positioned(
              top: -24,
              right: -24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), topRight: Radius.circular(20)),
                ),
                child: const Text('RECOMENDADO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: AppColors.onSurface)),
                    const SizedBox(height: 4),
                    Text(desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                    if (recommended) ...[
                      const SizedBox(height: 8),
                      Text('Ideal para profissionais e acadêmicos.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outline, width: 2),
                ),
                child: isSelected ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer))) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
