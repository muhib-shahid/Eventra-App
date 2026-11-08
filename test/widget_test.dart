import 'package:flutter_test/flutter_test.dart';
import 'package:eventra_app/main.dart';

void main() {
  testWidgets('Eventra app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const EventraApp());

    expect(find.text('Eventra'), findsWidgets);
  });
}
