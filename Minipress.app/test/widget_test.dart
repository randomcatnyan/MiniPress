import 'package:flutter_test/flutter_test.dart';

import 'package:minipress_app/main.dart';

void main() {
  testWidgets('MiniPress app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniPressApp());
    expect(find.text('MiniPress'), findsOneWidget);
  });
}
