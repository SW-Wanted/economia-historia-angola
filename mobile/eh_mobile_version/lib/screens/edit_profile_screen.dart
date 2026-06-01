import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: 'António Gonçalves');
  final TextEditingController _emailController = TextEditingController(text: 'antonio.goncalves@uanc.ao');
  final TextEditingController _institutionController = TextEditingController(text: 'Universidade Agostinho Neto');

  bool _pushNotifications = true;
  bool _weeklyNewsletter = false;

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  void _changePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seletor de imagem aberto!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: const Text(
          'Editar perfil',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Image Editor
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerHighest,
                                  border: Border.all(color: AppColors.primaryFixed, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x0D000000),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'AS',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _changePhoto,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _changePhoto,
                            child: const Text(
                              'Alterar foto de perfil',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Inputs Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nome
                          const Text(
                            'Nome',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              fillColor: AppColors.surface,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.outlineVariant),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.outlineVariant),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'O nome é obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Email
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: AppColors.surface,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.outlineVariant),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.outlineVariant),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'O email é obrigatório';
                              }
                              if (!value.contains('@')) {
                                return 'Insira um email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Instituição
                          const Text(
                            'Instituição',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _institutionController,
                            decoration: InputDecoration(
                              fillColor: AppColors.surface,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.outlineVariant),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.outlineVariant),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Preferences Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preferências',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notificações Push',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Alertas de novos artigos e debates',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _pushNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _pushNotifications = value;
                                  });
                                },
                                activeColor: Colors.white,
                                activeTrackColor: AppColors.primaryContainer,
                                inactiveThumbColor: AppColors.secondary,
                                inactiveTrackColor: AppColors.secondaryFixed,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.only(top: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Boletim Semanal',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Resumo da economia histórica',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _weeklyNewsletter,
                                  onChanged: (value) {
                                    setState(() {
                                      _weeklyNewsletter = value;
                                    });
                                  },
                                  activeColor: Colors.white,
                                  activeTrackColor: AppColors.primaryContainer,
                                  inactiveThumbColor: AppColors.secondary,
                                  inactiveTrackColor: AppColors.secondaryFixed,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Fixed Save Button at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.outlineVariant, width: 1),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Salvar alterações',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
