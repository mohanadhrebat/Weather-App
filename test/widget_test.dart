// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';

  void main() {
  testWidgets('WeatherApp builds without crashing', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const WeatherApp());

    // Let first frame render
    await tester.pump();

    // Basic checks: app is on screen
    expect(find.byType(MaterialApp), findsOneWidget);

    // Optional: check that at least something is rendered
    expect(find.byType(Scaffold), findsWidgets);
  });
}

