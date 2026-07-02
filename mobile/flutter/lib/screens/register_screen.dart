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
  // Total de passos do cadastro.
  static const _steps = 3;

  // Categorias sugeridas para personalização de conteúdos (Tela 2).
  static const _categories = [
    'História Económica',
    'Economia Colonial',
    'Economia Africana',
    'Desenvolvimento Económico',
    'Comércio Internacional',
    'Políticas Públicas',
    'Agricultura',
    'Recursos Naturais',
    'Industrialização',
    'Finanças',
    'Empreendedorismo',
    'História de Angola',
  ];

  final _draft = RegistrationDraft.instance;
  bool _loading = false;

  // Tela 1 — dados básicos.
  late final TextEditingController _name;
  late final TextEditingController _email;

  // Tela 2 — motivação.
  late final TextEditingController _motivation;

  // Tela 3 — segurança.
  late final TextEditingController _password;
  late final TextEditingController _confirm;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _draft.name);
    _email = TextEditingController(text: _draft.email);
    _motivation = TextEditingController(text: _draft.motivation);
    _password = TextEditingController(text: _draft.password);
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
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

  // ---------------------------------------------------------------------------
  // Navegação entre passos
  // ---------------------------------------------------------------------------

  void _submitStep1() {
    final email = _email.text.trim();
    if (_name.text.trim().isEmpty || email.isEmpty) {
      _snack('Indique o nome e o email.');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _snack('Indique um email válido.');
      return;
    }
    _draft
      ..name = _name.text.trim()
      ..email = email;
    Navigator.pushNamed(context, AppRoutes.register2);
  }

  void _goToStep3() {
    // As categorias já são guardadas em tempo real; persiste a motivação.
    _draft.motivation = _motivation.text.trim();
    Navigator.pushNamed(context, AppRoutes.register3);
  }

  // Validações em tempo real da Tela 3.
  bool get _passwordLongEnough => _password.text.length >= 8;
  bool get _passwordsMatch => _confirm.text.isNotEmpty && _password.text == _confirm.text;
  bool get _canCreateAccount => _passwordLongEnough && _passwordsMatch;

  Future<void> _finalize() async {
    if (!_canCreateAccount) return;
    _draft.password = _password.text;
    final asWriter = _draft.asWriter;
    setState(() => _loading = true);
    try {
      // 1) A conta é SEMPRE criada como utilizador comum (USER).
      await BackendService.instance.register(
        name: _draft.name,
        email: _draft.email,
        password: _draft.password,
      );

      // 2) Se pediu candidatura, envia-a já autenticado (status PENDING).
      var applicationSent = asWriter;
      if (asWriter) {
        try {
          await BackendService.instance.submitWriterApplication(_draft.toWriterApplication());
        } catch (_) {
          applicationSent = false;
        }
      }

      _draft.clear();
      if (!mounted) return;
      setState(() => _loading = false);
      await _showSuccess(asWriter: asWriter, applicationSent: applicationSent);
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

  /// Confirmação clara: a conta foi criada; a candidatura (se pedida) ainda
  /// aguarda aprovação da administração.
  Future<void> _showSuccess({required bool asWriter, required bool applicationSent}) {
    final body = !asWriter
        ? 'Conta criada com sucesso.'
        : applicationSent
            ? 'Conta criada com sucesso.\n\nA sua candidatura para Escritor foi enviada e será analisada pela administração.'
            : 'Conta criada com sucesso.\n\nNão foi possível enviar a candidatura para Escritor agora. Pode reenviá-la mais tarde a partir do seu perfil.';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        icon: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 40),
        title: const Text('Tudo pronto'),
        content: Text(body, style: const TextStyle(color: AppColors.secondary, height: 1.45)),
        actions: [
          EhButton(label: 'Continuar', onPressed: () => Navigator.of(dialogContext).pop()),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    return ScreenFrame(
      title: 'Cadastro $step/$_steps',
      showBack: true,
      showNotifications: false,
      children: [
        LinearProgressIndicator(value: step / _steps, color: AppColors.primary, backgroundColor: AppColors.outlineVariant),
        const SizedBox(height: 24),
        Text(_titleFor(step), style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 20),
        if (step == 1) ..._step1(context),
        if (step == 2) ..._step2(context),
        if (step == 3) ..._step3(context),
        const SizedBox(height: 28),
        ..._actions(step),
      ],
    );
  }

  String _titleFor(int step) => switch (step) {
        1 => 'Dados básicos',
        2 => 'Personalize a sua experiência',
        _ => 'Crie uma palavra-passe',
      };

  List<Widget> _actions(int step) => switch (step) {
        1 => [EhButton(label: 'Continuar', onPressed: _loading ? null : _submitStep1)],
        2 => [
            EhButton(label: 'Continuar', onPressed: _goToStep3),
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                onPressed: _goToStep3,
                style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
                child: const Text('Saltar'),
              ),
            ),
          ],
        _ => [
            EhButton(
              label: _loading ? 'A criar conta...' : 'Criar conta',
              onPressed: (_loading || !_canCreateAccount) ? null : _finalize,
            ),
          ],
      };

  // ---------------------------------------------------------------------------
  // Tela 1 — Dados básicos
  // ---------------------------------------------------------------------------

  List<Widget> _step1(BuildContext context) => [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 14),
        TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
        const SizedBox(height: 20),
        _writerSwitch(context),
      ];

  /// Switch que comunica que a candidatura é uma funcionalidade adicional,
  /// não um tipo de conta diferente.
  Widget _writerSwitch(BuildContext context) {
    final on = _draft.asWriter;
    return Container(
      decoration: BoxDecoration(
        color: on ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: on ? AppColors.primary : AppColors.outlineVariant, width: on ? 1.4 : 1),
      ),
      padding: const EdgeInsets.fromLTRB(14, 6, 8, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Candidatar-me a Escritor',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15.5),
                ),
              ),
              Switch.adaptive(
                value: on,
                activeThumbColor: AppColors.primary,
                onChanged: (value) => setState(() => _draft.asWriter = value),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6, top: 2),
            child: Text(
              'Os escritores podem publicar artigos e contribuir com conteúdos '
              'educativos. A candidatura será analisada pela administração.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tela 2 — Áreas de interesse
  // ---------------------------------------------------------------------------

  List<Widget> _step2(BuildContext context) {
    final selected = _draft.interests;
    return [
      Text(
        'Estas informações ajudam-nos a recomendar conteúdos mais relevantes para si.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.4),
      ),
      const SizedBox(height: 20),
      _categorySelect(context, selected),
      // Chips das categorias escolhidas — ocupam apenas o espaço necessário.
      AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topLeft,
        child: selected.isEmpty
            ? const SizedBox(width: double.infinity)
            : Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [for (final category in selected) _selectedChip(category)],
                ),
              ),
      ),
      const SizedBox(height: 22),
      TextField(
        controller: _motivation,
        minLines: 3,
        maxLines: 5,
        maxLength: 280,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          labelText: 'Motivação',
          hintText: 'Conte-nos o que o motivou a aderir à aplicação...',
          alignLabelWithHint: true,
        ),
      ),
    ];
  }

  /// Select List compacta (multi-seleção) que abre a lista de categorias sobre
  /// o campo, mantendo a tela limpa. Evita duplicações através de um Set.
  Widget _categorySelect(BuildContext context, Set<String> selected) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
      menuChildren: [
        for (final category in _categories)
          MenuItemButton(
            closeOnActivate: false,
            leadingIcon: Icon(
              selected.contains(category) ? Icons.check_box_outlined : Icons.check_box_outline_blank,
              size: 20,
              color: selected.contains(category) ? AppColors.primary : AppColors.secondary,
            ),
            onPressed: () => setState(() {
              selected.contains(category) ? selected.remove(category) : selected.add(category);
            }),
            child: Text(category),
          ),
      ],
      builder: (context, controller, child) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Categorias',
            prefixIcon: Icon(Icons.category_outlined),
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          child: Text(
            selected.isEmpty
                ? 'Selecione as áreas de interesse'
                : '${selected.length} ${selected.length == 1 ? 'área selecionada' : 'áreas selecionadas'}',
            style: TextStyle(
              color: selected.isEmpty ? AppColors.secondary : AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedChip(String category) => InputChip(
        label: Text(category),
        onDeleted: () => setState(() => _draft.interests.remove(category)),
        deleteIcon: const Icon(Icons.close, size: 16),
        deleteIconColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        backgroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
      );

  // ---------------------------------------------------------------------------
  // Tela 3 — Segurança
  // ---------------------------------------------------------------------------

  List<Widget> _step3(BuildContext context) => [
        TextField(
          controller: _password,
          obscureText: _obscurePassword,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Palavra-passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              tooltip: _obscurePassword ? 'Mostrar' : 'Ocultar',
            ),
          ),
        ),
        const SizedBox(height: 8),
        _validationHint(
          ok: _passwordLongEnough,
          neutral: _password.text.isEmpty,
          text: 'Pelo menos 8 caracteres',
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _confirm,
          obscureText: _obscureConfirm,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Confirmar palavra-passe',
            prefixIcon: const Icon(Icons.verified_user_outlined),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              tooltip: _obscureConfirm ? 'Mostrar' : 'Ocultar',
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_confirm.text.isNotEmpty)
          _validationHint(
            ok: _passwordsMatch,
            neutral: false,
            text: _passwordsMatch ? 'As palavras-passe coincidem' : 'As palavras-passe não coincidem',
          ),
      ];

  /// Linha de feedback imediato com ícone e cor consoante o estado.
  Widget _validationHint({required bool ok, required bool neutral, required String text}) {
    final color = neutral ? AppColors.secondary : (ok ? AppColors.success : AppColors.error);
    final icon = neutral
        ? Icons.radio_button_unchecked
        : (ok ? Icons.check_circle_outline : Icons.cancel_outlined);
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
