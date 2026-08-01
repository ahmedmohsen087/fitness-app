import 'package:easy_localization/easy_localization.dart';
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
    final _ = context.locale;

    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final isFullBody = selectedMuscleGroupId == null;
        final isLoading = _getIsLoading(state, isFullBody);
        final workouts = _getWorkouts(state, isFullBody);

        if (!isLoading && workouts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildGrid(isLoading, workouts);
      },
    );
  }

  bool _getIsLoading(FitnessState state, bool isFullBody) {
    return isFullBody
        ? state.recommendationToDayState.isLoading
        : state.musclesByGroupState.isLoading;
  }

  List<MuscleEntity> _getWorkouts(FitnessState state, bool isFullBody) {
    return isFullBody
        ? state.recommendationToDayState.data ?? []
        : state.musclesByGroupState.data ?? [];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        AppStrings.noWorkoutsFound,
        style: TextStyles.bodyRegular16,
      ),
    );
  }

  Widget _buildGrid(bool isLoading, List<MuscleEntity> workouts) {
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
        itemBuilder: (context, index) =>
            _buildItem(context, isLoading, workouts, index),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    bool isLoading,
    List<MuscleEntity> workouts,
    int index,
  ) {
    if (isLoading) {
      return const WorkoutCard(
        image: '',
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
  }
}
