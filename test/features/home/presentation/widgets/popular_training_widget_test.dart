import 'dart:async';

import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/fitness/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/home/presentation/widgets/popular_training_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_training_widget_test.mocks.dart';

@GenerateMocks([FitnessViewModel])
void main() {
  late MockFitnessViewModel mockFitnessViewModel;

  setUp(() {
    mockFitnessViewModel = MockFitnessViewModel();
    provideDummy<FitnessState>(const FitnessState());
  });

  Widget buildWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<FitnessViewModel>.value(
          value: mockFitnessViewModel,
          child: const PopularTrainingWidget(),
        ),
      ),
    );
  }

  testWidgets('renders skeleton list when popularTrainingState is loading', (
    tester,
  ) async {
    final streamController = StreamController<FitnessState>.broadcast();
    addTearDown(streamController.close);

    const loadingState = FitnessState(
      popularTrainingState: BaseState(isLoading: true),
    );

    when(mockFitnessViewModel.state).thenReturn(loadingState);
    when(mockFitnessViewModel.stream).thenAnswer((_) => streamController.stream);

    await tester.pumpWidget(buildWidget());

    expect(find.byType(PopularTrainingWidget), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('renders items list correctly on success state', (tester) async {
    final streamController = StreamController<FitnessState>.broadcast();
    addTearDown(streamController.close);

    const testItem = PopularTrainingEntity(
      id: '1',
      muscleName: 'Chest Press',
      image: 'http://example.com/chest.png',
      totalExercises: 12,
      difficultyLevel: 'Hard',
      primeMoverMuscleId: 'm1',
      difficultyLevelId: 'd1',
    );

    const successState = FitnessState(
      popularTrainingState: BaseState(
        isLoading: false,
        data: [testItem],
      ),
    );

    when(mockFitnessViewModel.state).thenReturn(successState);
    when(mockFitnessViewModel.stream).thenAnswer((_) => streamController.stream);

    await tester.pumpWidget(buildWidget());

    expect(find.text('Chest Press'), findsOneWidget);
    expect(find.text('12 Exercises'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });
}
