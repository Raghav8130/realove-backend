import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:realove_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RealoveApp());

    // Verify that the onboarding page shows up
    expect(find.text('Welcome to Realove AI'), findsOneWidget);
    expect(find.text('Start Chatting'), findsOneWidget);

    // Tap the start chatting button
    await tester.tap(find.text('Start Chatting'));
    await tester.pumpAndSettle();

    // Verify navigation to voice page
    expect(find.text('Voice Companion'), findsOneWidget);
    expect(find.text('Tap to speak'), findsOneWidget);
  });

  testWidgets('Settings navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const RealoveApp());
    
    // Navigate to voice page first
    await tester.tap(find.text('Start Chatting'));
    await tester.pumpAndSettle();
    
    // Find and tap the settings button
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    
    // Verify settings page
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Voice Gender'), findsOneWidget);
  });

  testWidgets('History navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const RealoveApp());
    
    // Navigate to voice page first
    await tester.tap(find.text('Start Chatting'));
    await tester.pumpAndSettle();
    
    // Find and tap the history button
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    
    // Verify history page
    expect(find.text('Chat History'), findsOneWidget);
    expect(find.text('No chat history yet'), findsOneWidget);
  });
}