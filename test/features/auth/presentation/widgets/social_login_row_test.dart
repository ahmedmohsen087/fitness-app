import 'package:fitness_app/features/auth/presentation/widgets/social_login_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SocialLoginRow', () {
    testWidgets('renders exactly three SvgPicture icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SocialLoginRow())),
      );

      expect(find.byType(SvgPicture), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  });
}
