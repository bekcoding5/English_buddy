import 'package:flutter_test/flutter_test.dart';
import 'package:english_buddy/main.dart';

void main() {
  testWidgets('Bosh ekranda English Buddy yozuvi bor', (tester) async {
    await tester.pumpWidget(const EnglishBuddy());
    expect(find.text('English Buddy'), findsOneWidget);
  });
}