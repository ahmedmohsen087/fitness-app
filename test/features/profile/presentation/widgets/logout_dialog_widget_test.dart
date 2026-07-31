import 'dart:async';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:fitness_app/features/profile/presentation/widgets/logout_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_dialog_widget_test.mocks.dart';

@GenerateMocks([LogoutViewModel])
void main() {
  late MockLogoutViewModel mockLogoutViewModel;

  setUp(() {
    mockLogoutViewModel = MockLogoutViewModel();
    when(mockLogoutViewModel.state).thenReturn(const LogoutState());
    when(mockLogoutViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('renders logout dialog contents correctly and handles cancel', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        routes: {
          AppRoutsName.loginScreen: (_) =>
              const Scaffold(body: Text('Login Screen')),
        },
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    LogoutDialog.show(context, mockLogoutViewModel);
                  },
                  child: const Text('Show Dialog'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.areYouSureYouWantToLogout), findsOneWidget);
    expect(find.text(AppStrings.no), findsOneWidget);
    expect(find.text(AppStrings.yes), findsOneWidget);
    expect(find.byType(Dialog), findsOneWidget);

    await tester.tap(find.text(AppStrings.no));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
    verifyZeroInteractions(mockLogoutViewModel);
  });

  testWidgets(
    'triggers LogoutRequestEvent when yes button is tapped and tests view model interaction',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutsName.loginScreen: (_) =>
                const Scaffold(body: Text('Login Screen')),
          },
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      LogoutDialog.show(context, mockLogoutViewModel);
                    },
                    child: const Text('Show Dialog'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.yes));
      await tester.pumpAndSettle();

      verify(
        mockLogoutViewModel.doEvent(argThat(isA<LogoutRequestEvent>())),
      ).called(1);
      expect(find.byType(Dialog), findsNothing);
      expect(find.text('Login Screen'), findsOneWidget);
    },
  );
}
