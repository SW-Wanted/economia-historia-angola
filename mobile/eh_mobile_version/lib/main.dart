import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kIsWeb && !kReleaseMode,
      builder: (_) => const EconomiaHistoriaApp(),
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
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Economia com Historia Angola',
        theme: AppTheme.light(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
