import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_hiding_app/views/home_page.dart';

void main() {
  testWidgets('HomePage renders correctly and has main buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // Verify that the title is present
    expect(find.text('StegaCrypt'), findsOneWidget);
    expect(find.text('Hide. Encrypt. Protect.'), findsOneWidget);

    // Verify the action cards are present
    expect(find.text('Hide Data'), findsOneWidget);
    expect(find.text('Extract Data'), findsOneWidget);
    expect(find.text('Start Hiding'), findsOneWidget);
    expect(find.text('Extract Secret'), findsOneWidget);
  });
}
