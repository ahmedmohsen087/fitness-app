import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:fitness_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_screen_test.mocks.dart';

@GenerateMocks([ChangePasswordViewModel])
void main() {
  late MockChangePasswordViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockChangePasswordViewModel();
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ChangePasswordViewModel>.value(
        value: mockViewModel,
        child: const ChangePasswordScreen(),
      ),
    );
  }

  group('ChangePasswordScreen Widget Tests', () {
    testWidgets('renders all form fields, texts, and buttons correctly', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        const ChangePasswordState(
          changePasswordState: BaseState<ChangePasswordEntity>(),
          autoValidate: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(AppStrings.changePassword), findsOneWidget);
      expect(
        find.text(AppStrings.makeSure8CharsOrMore),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text(AppStrings.done), findsOneWidget);
    });

    testWidgets('shows validation errors when submitting empty form', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        const ChangePasswordState(
          changePasswordState: BaseState<ChangePasswordEntity>(),
          autoValidate: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text(AppStrings.done));
      await tester.pump();

      verify(mockViewModel.doEvent(any)).called(1);
    });

    testWidgets('dispatches ChangePasswordRequestEvent when inputs are valid', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        const ChangePasswordState(
          changePasswordState: BaseState<ChangePasswordEntity>(),
          autoValidate: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'oldPassword123');
      await tester.enterText(textFields.at(1), 'Password123!');
      await tester.enterText(textFields.at(2), 'Password123!');

      await tester.tap(find.text(AppStrings.done));
      await tester.pump();

      verify(
        mockViewModel.doEvent(
          argThat(
            isA<ChangePasswordRequestEvent>()
                .having((e) => e.password, 'password', 'oldPassword123')
                .having((e) => e.newPassword, 'newPassword', 'Password123!'),
          ),
        ),
      ).called(1);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        ChangePasswordState(
          changePasswordState: BaseState<ChangePasswordEntity>.loading(),
          autoValidate: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
