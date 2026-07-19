import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fitness_app/config/app_launch/app_launch_manager.dart';
import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/secure_storage/secure_storage_service.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_launch_manager_test.mocks.dart';

@GenerateMocks([SecureStorageService, CacheStore])
void main() {
  late MockSecureStorageService storage;
  late AuthManager authManager;
  late AppLaunchManager launchManager;

  setUp(() {
    storage = MockSecureStorageService();
    authManager = AuthManager(storage, MockCacheStore());
    launchManager = AppLaunchManager(storage, authManager);
  });

  test('shows onboarding once and records that it was shown', () async {
    when(storage.readSeenOnboarding()).thenAnswer((_) async => false);
    when(storage.writeSeenOnboarding(true)).thenAnswer((_) async {});

    final destination = await launchManager.resolveDestination();

    expect(destination, AppRoutsName.onBoarding);
    verify(storage.writeSeenOnboarding(true)).called(1);
  });

  test('opens login after onboarding when no session is remembered', () async {
    when(storage.readSeenOnboarding()).thenAnswer((_) async => true);

    final destination = await launchManager.resolveDestination();

    expect(destination, AppRoutsName.loginScreen);
    verifyNever(storage.writeSeenOnboarding(any));
  });

  test('opens the app when a remembered session was initialized', () async {
    when(storage.readRememberMe()).thenAnswer((_) async => true);
    when(storage.readToken()).thenAnswer((_) async => 'saved-token');
    when(storage.readSeenOnboarding()).thenAnswer((_) async => true);
    await authManager.init();

    final destination = await launchManager.resolveDestination();

    expect(destination, AppRoutsName.sectionApp);
  });
}
