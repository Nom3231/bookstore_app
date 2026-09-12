import 'package:flutter_test/flutter_test.dart';
import 'package:bookstore_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
