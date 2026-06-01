import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.history_edu, color: AppColors.onPrimary, size: 18),
            ),
            const SizedBox(width: 8),
            Text('Economia com História', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontSize: 14)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bem-vindo', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26, color: AppColors.primary)),
              const SizedBox(height: 8),
              Text('Acesse sua conta para continuar explorando a economia angolana.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
              const SizedBox(height: 32),
              
              // Email Field
              Text('E-mail', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'seu@email.com',
                  hintStyle: TextStyle(color: AppColors.secondaryContainer.withValues(alpha: 0.8)),
                  prefixIcon: const Icon(Icons.mail_outline, color: AppColors.onSurfaceVariant),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              // Password Field
              Text('Senha', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: AppColors.secondaryContainer.withValues(alpha: 0.8)),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.onSurfaceVariant),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.onSurfaceVariant),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 8),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  child: Text('Esqueci a senha', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Entrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Plus Jakarta Sans')),
                ),
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.outlineVariant)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OU', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, letterSpacing: 2.0)),
                  ),
                  const Expanded(child: Divider(color: AppColors.outlineVariant)),
                ],
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, size: 28, color: AppColors.onSurface), // Placeholder for google logo
                  label: const Text('Continuar com Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.onSurface)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDJ_6bjEyI_5Ve331zKvNBgF8_J9-aescSNSRb9whI8M4e-lvhyh2yow_lItwTr0qt2FXQJiwqLmQplWMV_WezxwJQX4nBN_d0vOHGfFqzk5WKne0K_GcfDFQqoKyzByoDzd91muroU3fHTTN5FBAd-ivQ6x6eP-YSkUxDK2F9Ty6PjyOhM-ypjor37NK-ekmL_ukzbN6zmffuZKKLzAUehzA4NbVT59qubhh9Mpi_nMtJYbdt9bNw1Yd9pSjwmYp7hgTFxH3LDC60',
                  height: 128,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 128, color: AppColors.surfaceVariant),
                ),
              ),
              
              const SizedBox(height: 32),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ainda não tem uma conta?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.register1),
                      child: Text('Criar conta', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
