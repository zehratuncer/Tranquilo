import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tranquilo/main.dart';

void main() {
  testWidgets('Tranquilo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TranquiloApp()));
    expect(find.textContaining('Tranquilo'), findsOneWidget);
  });
}
