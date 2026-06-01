import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: const Color(0x0D000000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Explorar por região', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Interactive Map Section
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [AppColors.surfaceContainerLow, AppColors.background],
                center: Alignment.center,
                radius: 1.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.2,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDrJqbd9hnHQqvWxWXTkah9RWtqTNJSFNgVZKGgpGlorGqnisCUpg1S6e8c_lcU0iVTC5RPGsXaxGk1r6WqMdjkvpRGRckh2wjTAOEN7pkEKXxRVFsmW6sZbUQx86Ld0yMrXBZFDdKoIbMSMOYZF3t3ctC4racHyqBCBe3FnUwDOYRzpNrCDvVC_Ft4UUPWkJYqBdDDHTTMG_xvZTJusHVBVQFApb9LEH975pu5vW9pQs8qx3aXRQ5yuGcjIXjgjbyvyuW8pdaOBjY',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.grey,
                    colorBlendMode: BlendMode.saturation,
                  ),
                ),
                // Highlighted Province Marker: Luanda
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.2,
                  left: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: const Icon(Icons.location_on, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                        child: const Text('Luanda', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // Other Subtle Markers
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: MediaQuery.of(context).size.width * 0.5,
                  child: Opacity(
                    opacity: 0.4,
                    child: const Icon(Icons.circle, color: AppColors.primary, size: 12),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: MediaQuery.of(context).size.width * 0.7,
                  child: Opacity(
                    opacity: 0.4,
                    child: const Icon(Icons.circle, color: AppColors.primary, size: 12),
                  ),
                ),
                // Floating Legend
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: const Text('SELECIONE UMA PROVÍNCIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1.0)),
                  ),
                ),
              ],
            ),
          ),
          
          // Sliding Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, -8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(width: 48, height: 6, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(4))),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Luanda', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary, fontSize: 30, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Capital económica e administrativa', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(16)),
                        child: Text('Região Litoral', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onPrimaryFixedVariant, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Indicators Grid
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PIB Regional', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                              const SizedBox(height: 4),
                              Text('~38.5%', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Contribuição Nacional', style: const TextStyle(color: AppColors.secondaryFixedDim, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('População', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
                              const SizedBox(height: 4),
                              Text('9.1M', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Estimativa 2024', style: const TextStyle(color: AppColors.secondaryFixedDim, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Action Button
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.provinceContents),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Ver conteúdos desta região', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Comparar com outra província', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
