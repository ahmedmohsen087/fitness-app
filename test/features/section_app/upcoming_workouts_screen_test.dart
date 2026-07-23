import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_entity.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_entity.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_muscle_entity.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_events.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_states.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_view_models.dart';
import 'package:fitness_app/features/section_app/upcoming_workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<HomeViewModel>()])
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

const _muscle = RecommendationToDayMuscleEntity(
  id: 'm1',
  name: 'High Chest Exercise',
  image: 'https://example.com/chest.png',
);

const _group = MusclesEntity(id: 'g1', name: 'Chest');

Widget _wrap(Widget child, HomeViewModel viewModel) {
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
        home: BlocProvider<HomeViewModel>.value(value: viewModel, child: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockHomeViewModel mockViewModel;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockViewModel = MockHomeViewModel();
  });

  group('Success State Tests', () {
    setUp(() {
      when(mockViewModel.selectedMuscleGroupId).thenReturn(null);
      when(mockViewModel.state).thenReturn(
        HomeState(
          recommendationToDayState: BaseState.success(
            const RecommendationToDayEntity(
              message: '',
              totalMuscles: 1,
              muscles: [_muscle],
            ),
          ),
          musclesGroupState: BaseState.success(
            const MusclesGroupEntity(message: '', musclesGroup: [_group]),
          ),
        ),
      );
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    });

    testWidgets(
      'should render Screen structure and Background Image properly',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
          );
          await tester.pumpAndSettle();

          expect(find.byType(UpcomingWorkoutsScreen), findsOneWidget);
          expect(find.byType(Image), findsWidgets); // Background + Cards
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
        await tester.pumpAndSettle();

        expect(find.text('High Chest Exercise'), findsOneWidget);
      });
    });

    testWidgets(
      'should trigger GetMusclesGroupByIdEvent event when a specific muscle tab is tapped',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
          );
          await tester.pumpAndSettle();

          final chestTabFinder = find.text('Chest');
          expect(chestTabFinder, findsOneWidget);

          await tester.tap(chestTabFinder);
          await tester.pump();

          verify(
            mockViewModel.doEvent(
              argThat(
                predicate<HomeEvent>(
                  (e) => e is GetMusclesGroupByIdEvent && e.id == 'g1',
                ),
              ),
            ),
          ).called(1);
        });
      },
    );
  });

  group('Loading State Tests', () {
    testWidgets('should show skeleton items when workouts are loading', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        when(mockViewModel.selectedMuscleGroupId).thenReturn(null);
        when(mockViewModel.state).thenReturn(
          HomeState(
            recommendationToDayState: BaseState.loading(),
            musclesGroupState: BaseState.success(
              const MusclesGroupEntity(message: '', musclesGroup: [_group]),
            ),
          ),
        );
        when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

        await tester.pumpWidget(
          _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
        );
        await tester
            .pump(); // Skeletonizer needs just a pump, not pumpAndSettle

        expect(find.text('Loading'), findsWidgets);
        expect(find.text('High Chest Exercise'), findsNothing);
      });
    });
  });

  group('Empty State Tests', () {
    testWidgets(
      'should show "No Workouts Found" message when workouts list is empty',
      (tester) async {
        await mockNetworkImagesFor(() async {
          when(mockViewModel.selectedMuscleGroupId).thenReturn(null);
          when(mockViewModel.state).thenReturn(
            HomeState(
              recommendationToDayState: BaseState.success(
                const RecommendationToDayEntity(
                  message: '',
                  totalMuscles: 0,
                  muscles: [],
                ),
              ),
              musclesGroupState: BaseState.success(
                const MusclesGroupEntity(message: '', musclesGroup: [_group]),
              ),
            ),
          );
          when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

          await tester.pumpWidget(
            _wrap(const UpcomingWorkoutsScreen(), mockViewModel),
          );
          await tester.pumpAndSettle();

          // Looks for translated string key from TestAssetLoader
          expect(find.text('No Workouts Found'), findsOneWidget);
        });
      },
    );
  });
}
