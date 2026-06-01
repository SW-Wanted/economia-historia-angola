import 'package:eh_mobile_version/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EconomiaHistoriaApp());

    expect(find.text('Economia com Historia'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });
}
