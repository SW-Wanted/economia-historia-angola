import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../services/api_client.dart';
import '../services/backend_service.dart';
import '../services/registration_draft.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.step});

  final int step;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Interesses generalizados (alinhados com o documento do cliente).
  static const _interests = [
    'Agricultura',
    'Recursos Naturais',
    'Economia Nacional',
    'História de Angola',
    'Comércio',
    'Educação',
    'Desenvolvimento Regional',
    'Cultura',
    'Empreendedorismo',
    'Finanças',
  ];

  final _draft = RegistrationDraft.instance;
  bool _loading = false;

  // Controladores do passo atual (criados conforme o passo).
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _course;
  late final TextEditingController _institution;
  late final TextEditingController _province;
  late final TextEditingController _motivation;
  late final TextEditingController _password;
  late final TextEditingController _confirm;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _draft.name);
    _email = TextEditingController(text: _draft.email);
    _course = TextEditingController(text: _draft.course);
    _institution = TextEditingController(text: _draft.institution);
    _province = TextEditingController(text: _draft.province);
    _motivation = TextEditingController(text: _draft.motivation);
    _password = TextEditingController(text: _draft.password);
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _course.dispose();
    _institution.dispose();
    _province.dispose();
    _motivation.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _onPrimary() async {
    final step = widget.step;
    if (step == 1) {
      if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
        _snack('Indique pelo menos o nome e o email.');
        return;
      }
      _draft
        ..name = _name.text.trim()
        ..email = _email.text.trim()
        ..course = _course.text.trim()
        ..institution = _institution.text.trim()
        ..province = _province.text.trim();
      Navigator.pushNamed(context, AppRoutes.register2);
    } else if (step == 2) {
      _draft.motivation = _motivation.text.trim();
      Navigator.pushNamed(context, AppRoutes.register3);
    } else {
      await _finalize();
    }
  }

  Future<void> _finalize() async {
    final password = _password.text;
    if (password.length < 8) {
      _snack('A senha deve ter pelo menos 8 caracteres.');
      return;
    }
    if (password != _confirm.text) {
      _snack('As senhas não coincidem.');
      return;
    }
    _draft.password = password;
    setState(() => _loading = true);
    try {
      await BackendService.instance.register(
        name: _draft.name,
        email: _draft.email,
        password: password,
      );
      _draft.clear();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.quickStart, (r) => false);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack(e.statusCode == 409 ? 'Já existe uma conta com este email.' : e.message);
    } catch (_) {
      // Sem ligação ao servidor — permite continuar em modo offline.
      if (!mounted) return;
      setState(() => _loading = false);
      _snack('Sem ligação ao servidor. A continuar em modo offline.');
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.quickStart, (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    return ScreenFrame(
      title: 'Cadastro $step/3',
      showBack: true,
      showNotifications: false,
      children: [
        LinearProgressIndicator(value: step / 3, color: AppColors.primary, backgroundColor: AppColors.outlineVariant),
        const SizedBox(height: 24),
        Text(
          step == 1
              ? 'Dados pessoais'
              : step == 2
                  ? 'Interesses e motivação'
                  : 'Segurança',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 20),
        if (step == 1) ..._step1(context),
        if (step == 2) ..._step2(context),
        if (step == 3) ..._step3(context),
        const SizedBox(height: 28),
        EhButton(
          label: _loading
              ? 'A criar conta...'
              : step == 3
                  ? 'Finalizar cadastro'
                  : 'Continuar',
          onPressed: _loading ? null : _onPrimary,
        ),
        if (step == 2) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register3),
              child: const Text('Saltar este passo', style: TextStyle(color: AppColors.secondary)),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _step1(BuildContext context) => [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 14),
        TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
        const SizedBox(height: 14),
        TextField(controller: _course, decoration: const InputDecoration(labelText: 'Curso', prefixIcon: Icon(Icons.school_outlined))),
        const SizedBox(height: 14),
        TextField(controller: _institution, decoration: const InputDecoration(labelText: 'Instituição', prefixIcon: Icon(Icons.account_balance_outlined))),
        const SizedBox(height: 14),
        TextField(controller: _province, decoration: const InputDecoration(labelText: 'Província', prefixIcon: Icon(Icons.place_outlined))),
      ];

  List<Widget> _step2(BuildContext context) => [
        Text('Escolha os temas que mais lhe interessam:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final interest in _interests)
              ChoiceChip(
                label: Text(interest),
                selected: _draft.interests.contains(interest),
                showCheckmark: false,
                onSelected: (_) => setState(() {
                  _draft.interests.contains(interest)
                      ? _draft.interests.remove(interest)
                      : _draft.interests.add(interest);
                }),
                labelStyle: TextStyle(
                  color: _draft.interests.contains(interest) ? Colors.white : AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: BorderSide(color: _draft.interests.contains(interest) ? AppColors.primary : AppColors.outlineVariant),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.favorite_outline, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Conte-nos um pouco sobre si', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Esta informação ajuda-nos a melhorar a sua experiência na plataforma. '
          'O campo é opcional — pode avançar sem preencher —, mas partilhar um pouco '
          'sobre si contribui para a personalização e a melhoria contínua.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.45),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _motivation,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'A minha motivação',
            hintText: 'Ex.: Quero perceber como a economia moldou a história de Angola...',
            alignLabelWithHint: true,
          ),
        ),
      ];

  List<Widget> _step3(BuildContext context) => [
        TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline))),
        const SizedBox(height: 14),
        TextField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar senha', prefixIcon: Icon(Icons.verified_user_outlined))),
      ];
}
