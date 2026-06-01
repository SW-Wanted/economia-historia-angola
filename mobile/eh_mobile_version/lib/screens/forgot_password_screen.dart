import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Recuperar acesso', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Illustration Section
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(color: AppColors.surfaceContainerLow, shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAnCODbXv-7HAYx3lXqZXsBaI9a1KIlq8w3je8sciMPiaO0zf2Eyv5wPMJkj6fTcGSvTcseRwxVLxDIlf-bNmduP8mGA7Xplwf2looE6dpzm6jiHi-uVDQV-mssU8AZvf_weX1hiBC4kfD4cL-xAfgWsvOm2GUyvoOCSRz57kyTjSnoKY1feWz35zWOh8r0BJVTMNNcLKgpqRAGkA7vhr8pw_al5gHxEGm8Jh8_f5PkI0nv-yuY8lcsEecxHcJgvu_ektXHR7rgbM0',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.lock_outline, size: 48, color: AppColors.outline),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
                      child: const Icon(Icons.lock, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Instructional Text
              Text('Esqueceu a sua senha?', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22, color: AppColors.onSurface)),
              const SizedBox(height: 8),
              Text(
                'Insira o seu e-mail para receber um link de recuperação.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary, height: 1.5),
              ),
              const SizedBox(height: 48),
              
              // Form Section
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text('Endereço de E-mail', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'exemplo@email.com',
                  hintStyle: TextStyle(color: AppColors.outlineVariant),
                  prefixIcon: const Icon(Icons.mail_outline, color: AppColors.outline),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              
              // Primary Action
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Enviar link', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(width: 8),
                      Icon(Icons.send, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),
              
              // Secondary Information
              Text('Ainda com problemas?', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {},
                child: Text('Contactar Apoio ao Cliente', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
