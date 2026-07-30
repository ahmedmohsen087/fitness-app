import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/recording_navigator_observer.dart';
@GenerateNiceMocks([MockSpec<ForgetPasswordViewModel>()])
import 'email_verification_screen_test.mocks.dart';

Widget _wrap(
  Widget child,
  ForgetPasswordViewModel viewModel, {
  NavigatorObserver? observer,
}) {
  return EasyLocalization(
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
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> controller;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    controller = StreamController<ForgetPasswordState>.broadcast();

    when(mockViewModel.state).thenReturn(const ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => controller.stream);
    when(mockViewModel.userEmail).thenReturn('user@example.com');
    when(mockViewModel.isClosed).thenReturn(false);
    when(mockViewModel.close()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await controller.close();
  });

  testWidgets('builds without throwing', (tester) async {
    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byType(EmailVerificationScreen), findsOneWidget);
  });

  testWidgets('renders 4 OTP digit fields and a confirm button', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets(
    'shows a validation error and does not call doEvent when the OTP is incomplete',
    (tester) async {
      await tester.pumpWidget(
        _wrap(const EmailVerificationScreen(), mockViewModel),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      final otpFields = find.byType(TextField);
      await tester.enterText(otpFields.at(0), '1');
      await tester.enterText(otpFields.at(1), '2');

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Code must be 4 digits'), findsOneWidget);
      verifyNever(mockViewModel.doEvent(any));
    },
  );

  testWidgets('calls doEvent with VerifyOtpEvent when a full OTP is entered', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    final otpFields = find.byType(TextField);
    await tester.enterText(otpFields.at(0), '1');
    await tester.enterText(otpFields.at(1), '2');
    await tester.enterText(otpFields.at(2), '3');
    await tester.enterText(otpFields.at(3), '4');

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    final captured =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as VerifyOtpEvent;
    expect(captured.verifyResetCodeRequestModel.resetCode, '1234');
  });

  testWidgets('calls doEvent with the saved email when resend is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    final richTextFinder = find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains("Didn't receive the code?"),
    );
    expect(richTextFinder, findsOneWidget);

    final richText = tester.widget<RichText>(richTextFinder);
    final rootSpan = richText.text as TextSpan;

    final resendSpan = rootSpan.children!.first as TextSpan;

    final recognizer = resendSpan.recognizer as TapGestureRecognizer;
    recognizer.onTap!();

    await tester.pumpAndSettle();

    final captured =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as SendForgetPasswordEmailEvent;
    expect(captured.forgetPasswordEmailRequestModel.email, 'user@example.com');
  });

  testWidgets('shows a loading indicator while verifyOtp is in progress', (
    tester,
  ) async {
    when(mockViewModel.state).thenReturn(
      const ForgetPasswordState(
        forgetPasswordState: BaseState(isLoading: true),
      ),
    );

    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an error toast when verifyOtp fails', (tester) async {
    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    controller.add(
      ForgetPasswordState(forgetPasswordState: BaseState.error('Invalid code')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Invalid code'), findsOneWidget);
  });

  testWidgets('navigates to reset password screen when verifyOtp succeeds', (
    tester,
  ) async {
    const entity = ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verify,
    );
    final observer = RecordingNavigatorObserver();

    await tester.pumpWidget(
      _wrap(const EmailVerificationScreen(), mockViewModel, observer: observer),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    controller.add(
      ForgetPasswordState(forgetPasswordState: BaseState.success(entity)),
    );
    await tester.pumpAndSettle();

    expect(observer.pushedRoutes, contains(AppRoutsName.resetPassword));
  });
}
