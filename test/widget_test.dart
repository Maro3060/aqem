import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aqem/core/widgets/special_icon.dart';

void main() {
  group('SpecialIcon', () {
    testWidgets('renders its child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SpecialIcon(content: Text('Aqem')),
          ),
        ),
      );

      expect(find.text('Aqem'), findsOneWidget);
    });

    testWidgets('applies the configured scale', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SpecialIcon(content: Text('X'), scale: 2.0),
          ),
        ),
      );

      final transform = tester.widget<Transform>(
        find.ancestor(
          of: find.text('X'),
          matching: find.byType(Transform),
        ),
      );

      expect(transform.transform.getMaxScaleOnAxis(), 2.0);
    });

    testWidgets('defaults to gradient + shadow when not disabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SpecialIcon(content: Text('Y')),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Transform),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      expect(decoration.boxShadow, isNotEmpty);
    });
  });
}
