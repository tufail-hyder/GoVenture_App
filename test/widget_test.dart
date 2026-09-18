// Basic smoke test — verifies GoVentureApp builds and renders whatever
// startScreen it's given, without crashing. main.dart decides the real
// startScreen (Onboarding/Login/Root) based on GetStorage + Firebase Auth
// state, so tests just supply a placeholder here.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goventure/main.dart';

void main() {
  testWidgets('GoVentureApp builds with a given startScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GoVentureApp(
        startScreen: Scaffold(body: Center(child: Text('Test Screen'))),
      ),
    );

    expect(find.text('Test Screen'), findsOneWidget);
  });
}