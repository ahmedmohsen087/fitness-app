import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_tile_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders profile tile item with default properties and handles tap',
    (tester) async {
      bool tapped = false;

      await _pumpWidget(
        tester,
        ProfileTileItem(
          leadingIcon: Assets.assetsIconsProfile,
          title: 'Personal Info',
          onTap: () => tapped = true,
        ),
      );

      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'renders profile tile item with custom trailing, text color, and icon color',
    (tester) async {
      await _pumpWidget(
        tester,
        ProfileTileItem(
          leadingIcon: Assets.assetsIconsLogout,
          title: 'Logout',
          trailing: const Icon(Icons.check_circle, color: AppColors.success),
          textColor: AppColors.red,
          iconColor: AppColors.red,
          onTap: () {},
        ),
      );

      expect(find.text('Logout'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsNothing);
      expect(tester.takeException(), isNull);
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
  await tester.pumpAndSettle();
}
