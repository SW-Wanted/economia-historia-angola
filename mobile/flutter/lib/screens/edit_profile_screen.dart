import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/eh_button.dart';
import '../widgets/screen_frame.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _course = 'Economia';

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Editar Perfil',
      showBack: true,
      children: [
        Center(
          child: Stack(
            children: [
              const CircleAvatar(radius: 46, backgroundColor: AppColors.primary,
                  child: Text('MK', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900))),
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                  child: const CircleAvatar(radius: 16, backgroundColor: AppColors.primary, child: Icon(Icons.camera_alt, size: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _label(context, 'Nome completo'),
        const TextField(decoration: InputDecoration(hintText: 'Manuel Kiala')),
        const SizedBox(height: 14),
        _label(context, 'Curso'),
        DropdownButtonFormField<String>(
          initialValue: _course,
          items: const ['Economia', 'Gestão', 'Direito', 'Engenharia', 'Ciencias Sociais', 'Outro']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _course = v ?? _course),
        ),
        const SizedBox(height: 14),
        _label(context, 'Motivacao pelo interesse na economia-história'),
        const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Conte-nos o que o motiva...')),
        const SizedBox(height: 14),
        _label(context, 'Província'),
        const TextField(decoration: InputDecoration(hintText: 'Luanda')),
        const SizedBox(height: 28),
        EhButton(
          label: 'Guardar alteracoes',
          icon: Icons.save_outlined,
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil atualizado'), behavior: SnackBarBehavior.floating));
          },
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 2),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
      );
}
