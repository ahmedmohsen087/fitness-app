import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/section_app/upcoming_workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<FitnessViewModel>()])
import 'upcoming_workouts_screen_test.mocks.dart';

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "workouts": "Workouts",
      "fullBody": "Full Body",
      "noWorkoutsFound": "No Workouts Found",
    };
  }
}

const _muscle = MuscleEntity(
  id: 'm1',
  name: 'High Chest Exercise',
  image: 'https://example.com/chest.png',
);

const _group = MuscleGroupEntity(id: 'g1', name: 'Chest');

Widget _wrap(Widget child, FitnessViewModel viewModel) {
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
        home: BlocProvider<FitnessViewModel>.value(
          value: viewModel,
          child: child,
        ),
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
  });

  group('Success State Tests', () {
    setUp(() {
      when(mockViewModel.state).thenReturn(
        FitnessState(
          recommendationToDayState: BaseState.success(const [_muscle]),
          muscleGroupsState: BaseState.success(const [_group]),
        ),
      );
    });

    testWidgets(
      'should render Screen structure and Background Image properly',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
          );
          await tester.pump(const Duration(milliseconds: 300));

          expect(find.text('Workouts'), findsOneWidget);
        });
      },
    );

    testWidgets('should show Full Body workouts inside Grid by default', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('High Chest Exercise'), findsOneWidget);
      });
    });

    testWidgets(
      'should trigger SelectMuscleGroupEvent when a specific muscle tab is tapped',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
          );
          await tester.pump(const Duration(milliseconds: 300));

          final chestTab = find.text('Chest');
          expect(chestTab, findsOneWidget);

          await tester.tap(chestTab);
          await tester.pump(const Duration(milliseconds: 300));

          verify(mockViewModel.doEvent(argThat(isA<SelectMuscleGroupEvent>())))
              .called(1);
        });
      },
    );
  });

  group('Loading State Tests', () {
    testWidgets('should show skeleton items when workouts are loading', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        const FitnessState(
          recommendationToDayState: BaseState(isLoading: true),
          muscleGroupsState: BaseState(isLoading: true),
        ),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
        );
        await tester.pump();

        expect(find.byType(UpcomingWorkoutsScreen), findsOneWidget);
      });
    });
  });

  group('Empty State Tests', () {
    testWidgets(
      'should show "No Workouts Found" message when workouts list is empty',
      (tester) async {
        when(mockViewModel.state).thenReturn(
          FitnessState(
            recommendationToDayState: BaseState.success(const []),
            muscleGroupsState: BaseState.success(const []),
          ),
        );

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
          );
          await tester.pump(const Duration(milliseconds: 300));

          expect(find.text('No Workouts Found'), findsOneWidget);
        });
      },
    );
  });
}
