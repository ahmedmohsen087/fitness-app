// test/features/auth/presentation/screens/reset_password_screen_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/recording_navigator_observer.dart';

@GenerateNiceMocks([MockSpec<ForgetPasswordViewModel>()])
import 'reset_password_screen_test.mocks.dart';

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
  });

  testWidgets('builds without throwing', (tester) async {
    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });

  testWidgets('renders two password fields, both obscured initially', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
  });

  testWidgets('toggles password visibility when the eye icon is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.visibility_off).first);
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('shows required validation errors when fields are empty', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
    verifyNever(mockViewModel.doEvent(any));
  });

  testWidgets('shows a mismatch error when the passwords do not match', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Passw0rd!');
    await tester.enterText(fields.at(1), 'Different1!');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
    verifyNever(mockViewModel.doEvent(any));
  });

  testWidgets(
    'calls doEvent with ResetPasswordEvent when passwords match and are valid',
    (tester) async {
      await tester.pumpWidget(
        _wrap(const ResetPasswordScreen(), mockViewModel),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Passw0rd!');
      await tester.enterText(fields.at(1), 'Passw0rd!');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final captured =
          verify(mockViewModel.doEvent(captureAny)).captured.single
              as ResetPasswordEvent;
      expect(captured.resetPasswordRequestModel.password, 'Passw0rd!');
      expect(captured.resetPasswordRequestModel.newPassword, 'Passw0rd!');
    },
  );

  testWidgets('shows a loading indicator while resetPassword is in progress', (
    tester,
  ) async {
    when(mockViewModel.state).thenReturn(
      const ForgetPasswordState(
        forgetPasswordState: BaseState(isLoading: true),
      ),
    );

    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an error toast when resetPassword fails', (tester) async {
    whenListen(
      mockViewModel,
      Stream.fromIterable([
        const ForgetPasswordState(
          forgetPasswordState: BaseState(isLoading: true),
        ),
        ForgetPasswordState(
          forgetPasswordState: BaseState.error('Reset failed'),
        ),
      ]),
      initialState: const ForgetPasswordState(),
    );

    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pump();
    await tester.pump();

    expect(find.text('Reset failed'), findsOneWidget);
  });

  testWidgets('navigates to the login screen on successful reset', (
    tester,
  ) async {
    const entity = ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.reset,
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
      _wrap(const ResetPasswordScreen(), mockViewModel, observer: observer),
    );
    await tester.pumpAndSettle();

    expect(observer.pushedRoutes, contains(AppRoutsName.loginScreen));
  });
}
