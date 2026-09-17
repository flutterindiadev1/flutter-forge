import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdev/app/app.dart';

void main() {
  testWidgets('FlutterForge app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterForgeApp());
    await tester.pump();
    // App renders without crash
    expect(find.byType(FlutterForgeApp), findsOneWidget);
  });
}
