import 'package:flutter/foundation.dart'; // Adicionado para usar kReleaseMode
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // 1. Importação do pacote

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'services/backend_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tipografia online com fallback ao sistema quando offline.
  AppTheme.configureFonts();

  // Recupera silenciosamente a sessão persistida (tokens de refresh válidos por
  // ~30 dias). Se falhar, arranca em modo não autenticado/offline-first.
  try {
    await BackendService.instance.restoreSession();
  } catch (_) {
    // Nunca bloquear o arranque por causa da sessão.
  }

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
