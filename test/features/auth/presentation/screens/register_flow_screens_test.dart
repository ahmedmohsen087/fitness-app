import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/auth/presentation/screens/activity_selection_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/age_selection_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/gender_selection_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/goal_selection_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/height_selection_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/register_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/weight_selection_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_model/register_events.dart';
import 'package:fitness_app/features/auth/presentation/view_model/register_state.dart';
import 'package:fitness_app/features/auth/presentation/view_model/register_view_model.dart';
import 'package:fitness_app/features/auth/presentation/widgets/gender_option_widget.dart';
import 'package:fitness_app/features/auth/presentation/widgets/register_number_picker.dart';
import 'package:fitness_app/features/auth/presentation/widgets/register_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numberpicker/numberpicker.dart';

import 'register_flow_screens_test.mocks.dart';

@GenerateMocks([RegisterViewModel])
void main() {
  late MockRegisterViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockRegisterViewModel();
    _stubViewModel(mockViewModel, const RegisterState());
    getIt.registerFactory<RegisterViewModel>(() => mockViewModel);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders and dispatches the complete localized register flow', (
    tester,
  ) async {
    final screen = ValueNotifier<Widget>(const RegisterScreen());
    await _pump(tester, screen);

    expect(find.byType(TextFormField), findsNWidgets(4));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'John');
    await tester.enterText(fields.at(1), 'Doe');
    await tester.enterText(fields.at(2), 'john.doe@test.com');
    await tester.enterText(fields.at(3), 'Test@123');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.register));
    await tester.pump();
    final credentials =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as ContinueToGenderEvent;
    expect(credentials.firstName, 'John');
    expect(credentials.email, 'john.doe@test.com');
    clearInteractions(mockViewModel);

    screen.value = GenderSelectionScreen(
      key: const ValueKey('gender-selected'),
      viewModel: mockViewModel,
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(AppStrings.registerStep(1)), findsOneWidget);
    expect(find.byType(GenderOptionWidget), findsNWidgets(2));
    final maleCenter = tester.getCenter(find.text(AppStrings.male));
    final femaleCenter = tester.getCenter(find.text(AppStrings.female));
    expect(maleCenter.dx, closeTo(femaleCenter.dx, 1));
    expect(maleCenter.dy, lessThan(femaleCenter.dy));
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );

    _stubViewModel(
      mockViewModel,
      const RegisterState(gender: RegisterConstants.genderMale),
    );
    screen.value = GenderSelectionScreen(viewModel: mockViewModel);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.next));
    final genderNext =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as ContinueRegistrationEvent;
    expect(genderNext.target, RegisterFlowStep.age);
    clearInteractions(mockViewModel);

    _stubViewModel(mockViewModel, const RegisterState());
    screen.value = AgeSelectionScreen(viewModel: mockViewModel);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.registerStep(2)), findsOneWidget);
    expect(find.byType(NumberPicker), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.next));
    final ageNext =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as ContinueRegistrationEvent;
    expect(ageNext.target, RegisterFlowStep.weight);
    clearInteractions(mockViewModel);

    screen.value = WeightSelectionScreen(viewModel: mockViewModel);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.registerStep(3)), findsOneWidget);
    expect(find.byType(NumberPicker), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, AppStrings.done),
      findsOneWidget,
    );

    screen.value = HeightSelectionScreen(viewModel: mockViewModel);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.registerStep(4)), findsOneWidget);
    expect(find.byType(NumberPicker), findsOneWidget);
    expect(find.text('167'), findsOneWidget);

    screen.value = GoalSelectionScreen(viewModel: mockViewModel);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.registerStep(5)), findsOneWidget);
    expect(find.byType(RegisterOptionTile), findsNWidgets(5));
    await tester.tap(find.text(AppStrings.goalGainWeight));
    final goal =
        verify(mockViewModel.doEvent(captureAny)).captured.single
            as SelectGoalEvent;
    expect(goal.goal, RegisterConstants.goalGainWeight);
    clearInteractions(mockViewModel);

    screen.value = ActivitySelectionScreen(
      key: const ValueKey('activity-loading'),
      viewModel: mockViewModel,
    );
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.registerStep(6)), findsOneWidget);
    expect(find.byType(RegisterOptionTile), findsNWidgets(5));
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );

    _stubViewModel(
      mockViewModel,
      const RegisterState(
        activityLevel: RegisterConstants.activityLevel1,
        submitState: BaseState(isLoading: true),
      ),
    );
    screen.value = ActivitySelectionScreen(viewModel: mockViewModel);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);

    screen.dispose();
  });

  testWidgets('keeps a selected two-digit picker value on one line', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 330,
            child: Column(
              children: [
                RegisterNumberPicker(
                  min: 40,
                  max: 200,
                  value: 90,
                  unit: AppStrings.kilogram,
                  onChanged: (_) {},
                ),
                RegisterNumberPicker(
                  min: 100,
                  max: 250,
                  value: 167,
                  unit: AppStrings.centimeter,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final paragraph = tester.renderObject<RenderParagraph>(find.text('90'));
    final boxes = paragraph.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: 2),
    );
    expect(boxes, hasLength(1));
    final threeDigitParagraph = tester.renderObject<RenderParagraph>(
      find.text('167'),
    );
    final threeDigitBoxes = threeDigitParagraph.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: 3),
    );
    expect(threeDigitBoxes, hasLength(1));
  });
}

void _stubViewModel(MockRegisterViewModel viewModel, RegisterState state) {
  when(viewModel.state).thenReturn(state);
  when(viewModel.stream).thenAnswer((_) => const Stream.empty());
  when(viewModel.isClosed).thenReturn(false);
  when(viewModel.close()).thenAnswer((_) async {});
}

Future<void> _pump(WidgetTester tester, ValueNotifier<Widget> screen) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: Builder(
        builder: (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: AppTheme.lightTheme,
          home: ValueListenableBuilder<Widget>(
            valueListenable: screen,
            builder: (_, value, _) => value,
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}
