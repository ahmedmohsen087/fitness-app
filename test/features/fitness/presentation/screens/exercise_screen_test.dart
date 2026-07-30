import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/fitness/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<FitnessViewModel>()])
import 'exercise_screen_test.mocks.dart';

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "workouts": "Workouts",
      "noWorkoutsFound": "No Workouts Found",
    };
  }
}

const _level = DifficultyLevelEntity(id: '1', name: 'Beginner');

const _exercise = ExerciseEntity(
  id: 'e1',
  exercise: 'Push Up',
  videoUrl: 'https://youtube.com/watch?v=12345678',
  primaryEquipment: 'Bodyweight',
  targetMuscleGroup: 'Chest',
  primeMoverMuscle: 'Chest',
  difficultyLevel: 'Beginner',
);

const _args = ExerciseScreenArgs(
  primeMoverMuscleId: 'm1',
  muscleName: 'Chest',
  image: 'https://example.com/chest.png',
);

Widget _wrap(Widget child) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    assetLoader: const TestAssetLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFitnessViewModel mockViewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    provideDummy<FitnessState>(const FitnessState());
  });

  setUp(() {
    mockViewModel = MockFitnessViewModel();
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.isClosed).thenReturn(false);

    if (GetIt.I.isRegistered<FitnessViewModel>()) {
      GetIt.I.unregister<FitnessViewModel>();
    }
    getIt.registerFactory<FitnessViewModel>(() => mockViewModel);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('ExerciseScreen Widget Tests', () {
    testWidgets('renders screen structure and header title', (tester) async {
      when(mockViewModel.state).thenReturn(
        FitnessState(
          difficultyLevelsState: BaseState.success(const [_level]),
          exercisesByDifficultyState: BaseState.success(const [_exercise]),
          selectedLevelId: '1',
        ),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(_wrap(const ExerciseScreen(args: _args)));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Chest Exercise'), findsOneWidget);
        expect(find.text('Push Up'), findsOneWidget);
      });
    });

    testWidgets('shows empty state when exercises list is empty', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        FitnessState(
          difficultyLevelsState: BaseState.success(const [_level]),
          exercisesByDifficultyState: BaseState.success(const []),
          selectedLevelId: '1',
        ),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(_wrap(const ExerciseScreen(args: _args)));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('No Workouts Found'), findsOneWidget);
      });
    });

    testWidgets('triggers SelectDifficultyLevelEvent when tab is tapped', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        FitnessState(
          difficultyLevelsState: BaseState.success(const [_level]),
          exercisesByDifficultyState: BaseState.success(const [_exercise]),
          selectedLevelId: '1',
        ),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(_wrap(const ExerciseScreen(args: _args)));
        await tester.pump(const Duration(milliseconds: 300));

        final tab = find.text('Beginner');
        expect(tab, findsOneWidget);

        await tester.tap(tab);
        await tester.pump(const Duration(milliseconds: 300));

        verify(mockViewModel.doEvent(argThat(isA<SelectDifficultyLevelEvent>())))
            .called(1);
      });
    });
  });
}
