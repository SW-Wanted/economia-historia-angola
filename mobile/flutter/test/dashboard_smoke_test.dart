import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eh_mobile_version/core/theme/app_theme.dart';
import 'package:eh_mobile_version/providers/app_state.dart';
import 'package:eh_mobile_version/screens/dashboard_screen.dart';

void main() {
  testWidgets('DashboardScreen builds without throwing', (tester) async {
    await tester.pumpWidget(
      AppStateScope(
        notifier: AppState(),
        child: MaterialApp(
          theme: AppTheme.light(),
          onGenerateRoute: (_) => null,
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
