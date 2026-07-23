import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:fitness_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/recording_navigator_observer.dart';

@GenerateNiceMocks([MockSpec<ForgetPasswordUseCase>()])
import 'forget_password_screen_test.mocks.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child,
  ForgetPasswordViewModel viewModel, {
  NavigatorObserver? observer,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: Builder(
        builder: (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          navigatorObservers: observer != null ? [observer] : const [],
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(),
          ),
          home: BlocProvider<ForgetPasswordViewModel>.value(
            value: viewModel,
            child: child,
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockForgetPasswordUseCase mockUseCase;
  late ForgetPasswordViewModel viewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockUseCase = MockForgetPasswordUseCase();
    viewModel = ForgetPasswordViewModel(mockUseCase);
    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      ErrorBaseResponse(errorMessage: ''),
    );

    if (getIt.isRegistered<ForgetPasswordViewModel>()) {
      getIt.unregister<ForgetPasswordViewModel>();
    }
    getIt.registerFactory<ForgetPasswordViewModel>(() => viewModel);
  });

  tearDown(() async {
    await viewModel.close();
    if (getIt.isRegistered<ForgetPasswordViewModel>()) {
      getIt.unregister<ForgetPasswordViewModel>();
    }
  });

  testWidgets('renders the email field and the submit button', (tester) async {
    await _pump(tester, const ForgetPasswordScreen(), viewModel);

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets(
    'shows a validation error and does not call useCase for an invalid email',
    (tester) async {
      await _pump(tester, const ForgetPasswordScreen(), viewModel);

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
      verifyNever(mockUseCase.forgetPassword(forgetPasswordEmailRequestModel: anyNamed('forgetPasswordEmailRequestModel')));
    },
  );

  testWidgets('calls useCase with the entered email when the form is valid', (
    tester,
  ) async {
    when(
      mockUseCase.forgetPassword(
        forgetPasswordEmailRequestModel: anyNamed('forgetPasswordEmailRequestModel'),
      ),
    ).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: const ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
        ),
      ),
    );

    await _pump(tester, const ForgetPasswordScreen(), viewModel);

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final captured =
        verify(
          mockUseCase.forgetPassword(
            forgetPasswordEmailRequestModel: captureAnyNamed(
              'forgetPasswordEmailRequestModel',
            ),
          ),
        ).captured.single;
    expect(captured.email, 'user@example.com');
  });

  testWidgets('navigates to the email verification screen on success', (
    tester,
  ) async {
    when(
      mockUseCase.forgetPassword(
        forgetPasswordEmailRequestModel: anyNamed('forgetPasswordEmailRequestModel'),
      ),
    ).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: const ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
        ),
      ),
    );

    final observer = RecordingNavigatorObserver();

    await _pump(
      tester,
      const ForgetPasswordScreen(),
      viewModel,
      observer: observer,
    );

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(
      observer.pushedRoutes,
      contains(AppRoutsName.emailVerificationScreen),
    );
  });

  testWidgets('shows an error toast when forgetPassword fails', (tester) async {
    when(
      mockUseCase.forgetPassword(
        forgetPasswordEmailRequestModel: anyNamed('forgetPasswordEmailRequestModel'),
      ),
    ).thenAnswer(
      (_) async => ErrorBaseResponse(errorMessage: 'Network error'),
    );

    await _pump(tester, const ForgetPasswordScreen(), viewModel);

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Network error', skipOffstage: false), findsOneWidget);
  });
}
