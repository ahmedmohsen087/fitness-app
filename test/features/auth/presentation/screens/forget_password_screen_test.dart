// test/features/auth/presentation/screens/forget_password_screen_test.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/recording_navigator_observer.dart';
@GenerateNiceMocks([MockSpec<ForgetPasswordViewModel>()])
import 'forget_password_screen_test.mocks.dart';

Widget _wrap(
  Widget child,
  ForgetPasswordViewModel viewModel, {
  NavigatorObserver? observer,
}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
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
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockForgetPasswordViewModel mockViewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();

    when(mockViewModel.state).thenReturn(const ForgetPasswordState());
    when(
      mockViewModel.stream,
    ).thenAnswer((_) => const Stream<ForgetPasswordState>.empty());

    if (getIt.isRegistered<ForgetPasswordViewModel>()) {
      getIt.unregister<ForgetPasswordViewModel>();
    }
    getIt.registerFactory<ForgetPasswordViewModel>(() => mockViewModel);
  });

  tearDown(() {
    if (getIt.isRegistered<ForgetPasswordViewModel>()) {
      getIt.unregister<ForgetPasswordViewModel>();
    }
  });

  testWidgets('renders the email field and the submit button', (tester) async {
    await tester.pumpWidget(_wrap(const ForgetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets(
    'shows a validation error and does not call doEvent for an invalid email',
    (tester) async {
      await tester.pumpWidget(
        _wrap(const ForgetPasswordScreen(), mockViewModel),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
      verifyNever(mockViewModel.doEvent(any));
    },
  );

  testWidgets('calls doEvent with the entered email when the form is valid', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ForgetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'user@example.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final captured =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as SendForgetPasswordEmailEvent;
    expect(captured.forgetPasswordEmailRequestModel.email, 'user@example.com');
  });

  testWidgets('shows a loading indicator while forgetPassword is in progress', (
    tester,
  ) async {
    when(mockViewModel.state).thenReturn(
      const ForgetPasswordState(
        forgetPasswordState: BaseState(isLoading: true),
      ),
    );

    await tester.pumpWidget(_wrap(const ForgetPasswordScreen(), mockViewModel));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('navigates to the email verification screen on success', (
    tester,
  ) async {
    const entity = ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
    );
    final observer = RecordingNavigatorObserver();

    whenListen(
      mockViewModel,
      Stream.fromIterable([
        const ForgetPasswordState(
          forgetPasswordState: BaseState(isLoading: true),
        ),
        ForgetPasswordState(forgetPasswordState: BaseState.success(entity)),
      ]),
      initialState: const ForgetPasswordState(),
    );

    await tester.pumpWidget(
      _wrap(const ForgetPasswordScreen(), mockViewModel, observer: observer),
    );
    await tester.pumpAndSettle();

    expect(
      observer.pushedRoutes,
      contains(AppRoutsName.emailVerificationScreen),
    );
  });

  testWidgets('shows an error toast when forgetPassword fails', (tester) async {
    whenListen(
      mockViewModel,
      Stream.fromIterable([
        const ForgetPasswordState(
          forgetPasswordState: BaseState(isLoading: true),
        ),
        ForgetPasswordState(
          forgetPasswordState: BaseState.error('Network error'),
        ),
      ]),
      initialState: const ForgetPasswordState(),
    );

    await tester.pumpWidget(_wrap(const ForgetPasswordScreen(), mockViewModel));
    await tester.pump();
    await tester.pump();

    expect(find.text('Network error'), findsOneWidget);
  });
}
