// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:test_project_v2/main.dart';

void main() {
  testWidgets('App loads and shows navigation destinations', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('SpaceX Explorer'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Rockets'), findsOneWidget);
    expect(find.text('Launches'), findsOneWidget);
  });
}
