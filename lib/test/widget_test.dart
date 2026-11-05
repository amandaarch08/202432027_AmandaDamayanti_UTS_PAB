
import 'package:flutter_test/flutter_test.dart';
import 'package:amaraga/main.dart';

void main() {
  testWidgets('Amaraga app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const AmaragaApp());

    expect(find.text('Good day,'), findsOneWidget);
    expect(find.text('Amanda! 👋'), findsOneWidget);
  });
}
