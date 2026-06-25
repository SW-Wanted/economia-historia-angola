import 'package:flutter/foundation.dart'; // Adicionado para usar kReleaseMode
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // 1. Importação do pacote

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';

void main() {
  // Tipografia online com fallback ao sistema quando offline.
  AppTheme.configureFonts();

  // 2. Envolver o app com o DevicePreview
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Ativa apenas em desenvolvimento
      builder: (context) => const EconomiaHistoriaApp(),
    ),
  );
}

class EconomiaHistoriaApp extends StatelessWidget {
  const EconomiaHistoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: AppState(),
      child: MaterialApp(
        // 3. Configurações necessárias para o DevicePreview funcionar perfeitamente
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        
        // Mantendo exatamente as suas configurações originais abaixo:
        debugShowCheckedModeBanner: false,
        title: 'Economia com Historia Angola',
        theme: AppTheme.light(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ), // MaterialApp
    ); // AppStateScope
  }
}
