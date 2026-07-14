import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reset_password_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ForgetPasswordViewModel>()])
Widget _wrap(Widget child, ForgetPasswordViewModel viewModel) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: Builder(
      builder: (context) => MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
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
    ).thenAnswer((_) => Stream<ForgetPasswordState>.empty());
  });

  testWidgets('ResetPasswordScreen builds without throwing', (tester) async {
    await tester.pumpWidget(_wrap(const ResetPasswordScreen(), mockViewModel));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });
}
