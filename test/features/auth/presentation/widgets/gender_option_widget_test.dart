import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/features/auth/presentation/widgets/gender_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenderOptionWidget', () {
    testWidgets('renders label and icon correctly', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderOptionWidget(
              label: 'Male',
              icon: Icons.male,
              isSelected: false,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Male'), findsOneWidget);
      expect(find.byIcon(Icons.male), findsOneWidget);

      await tester.tap(find.byType(GenderOptionWidget));
      expect(tapped, isTrue);
    });

    testWidgets('renders unselected state decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenderOptionWidget(
              label: 'Male',
              icon: Icons.male,
              isSelected: false,
              onTap: _dummyOnTap,
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);
      expect(decoration.border?.top.color, AppColors.white);
    });

    testWidgets('renders selected state decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenderOptionWidget(
              label: 'Male',
              icon: Icons.male,
              isSelected: true,
              onTap: _dummyOnTap,
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.orange);
      expect(decoration.border?.top.color, AppColors.orange);
    });
  });
}

void _dummyOnTap() {}
