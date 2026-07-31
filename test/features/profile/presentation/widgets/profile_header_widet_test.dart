import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_header_widet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders profile header with image and name correctly', (
    tester,
  ) async {
    bool backPressedCalled = false;

    await _pumpWidget(
      tester,
      ProfileHeaderWidget(
        imageUrl: '',
        userName: 'Mohamed Ebrahim',
        onBackPressed: () => backPressedCalled = true,
      ),
    );

    expect(find.text(AppStrings.profile), findsOneWidget);
    expect(find.text('Mohamed Ebrahim'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CustomNetworkImage), findsOneWidget);

    await tester.tap(find.byType(SvgPicture));
    expect(backPressedCalled, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders profile header with network image when url is provided',
    (tester) async {
      await _pumpWidget(
        tester,
        ProfileHeaderWidget(
          imageUrl: 'https://via.placeholder.com/150',
          userName: 'Mohamed Ebrahim',
          onBackPressed: () {},
        ),
      );

      final customImage = tester.widget<CustomNetworkImage>(
        find.byType(CustomNetworkImage),
      );
      expect(customImage.imageUrl, 'https://via.placeholder.com/150');
    },
  );

  testWidgets(
    'renders profile header without back button when onBackPressed is null',
    (tester) async {
      await _pumpWidget(
        tester,
        const ProfileHeaderWidget(
          imageUrl: '',
          userName: 'Mohamed Ebrahim',
        ),
      );

      expect(find.text(AppStrings.profile), findsOneWidget);
      expect(find.text('Mohamed Ebrahim'), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    },
  );
}

Future<void> _pumpWidget(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
  await tester.pump();
}
