import 'dart:async';

import 'package:fitness_app/config/app_launch/app_launch_manager.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/utils/app_routes.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_routes_test.mocks.dart';

@GenerateMocks([AppLaunchManager])
void main() {
  late MockAppLaunchManager launchManager;

  setUp(() async {
    await getIt.reset();
    launchManager = MockAppLaunchManager();
    when(
      launchManager.resolveDestination(),
    ).thenAnswer((_) => Completer<String>().future);
    getIt.registerSingleton<AppLaunchManager>(launchManager);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('uses splash as the only initial root route', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutsName.splashScreen,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    final context = tester.element(find.byType(SplashScreen));
    expect(Navigator.of(context).canPop(), isFalse);

    await tester.pump(const Duration(seconds: 3));
  });

  test('preserves route settings for registered routes', () {
    const settings = RouteSettings(name: AppRoutsName.onBoarding);

    final route = AppRoutes.onGenerateRoute(settings);

    expect(route.settings, same(settings));
  });
}
