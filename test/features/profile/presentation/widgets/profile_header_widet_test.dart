import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_header_widet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('renders profile header with image and name correctly', (
    tester,
  ) async {
    await _pumpWidget(
      tester,
      const ProfileHeaderWidget(imageUrl: '', userName: 'Mohamed Ebrahim'),
    );

    expect(find.text(AppStrings.profile), findsOneWidget);
    expect(find.text('Mohamed Ebrahim'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets(
    'renders profile header with network image when url is provided',
    (tester) async {
      await mockNetworkImagesFor(() async {
        await _pumpWidget(
          tester,
          const ProfileHeaderWidget(
            imageUrl: 'https://via.placeholder.com/150',
            userName: 'Mohamed Ebrahim',
          ),
        );

        final circleAvatar = tester.widget<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(circleAvatar.backgroundImage, isA<NetworkImage>());

        expect(
          (circleAvatar.backgroundImage as NetworkImage).url,
          'https://via.placeholder.com/150',
        );

        expect(find.byIcon(Icons.person), findsNothing);
      });
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
