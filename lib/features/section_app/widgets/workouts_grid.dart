import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/section_app/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkoutsGrid extends StatelessWidget {
  final String? selectedMuscleGroupId;

  const WorkoutsGrid({super.key, required this.selectedMuscleGroupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final isFullBody = selectedMuscleGroupId == null;

        final isLoading = isFullBody
            ? state.recommendationToDayState.isLoading
            : state.musclesByGroupState.isLoading;

        final List<MuscleEntity> workouts = isFullBody
            ? state.recommendationToDayState.data ?? []
            : state.musclesByGroupState.data ?? [];

        if (!isLoading && workouts.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noWorkoutsFound,
              style: TextStyles.bodyRegular16,
            ),
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: .85,
            ),
            itemCount: isLoading ? 6 : workouts.length,
            itemBuilder: (context, index) {
              if (isLoading) {
                return const WorkoutCard(
                  image: 'https://iili.io/33pY9AN.png',
                  title: 'Loading',
                );
              }

              final workout = workouts[index];
              return WorkoutCard(
                image: workout.image,
                title: workout.name,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutsName.exercise,
                    arguments: ExerciseScreenArgs(
                      primeMoverMuscleId: workout.id,
                      muscleName: workout.name,
                      image: workout.image,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
