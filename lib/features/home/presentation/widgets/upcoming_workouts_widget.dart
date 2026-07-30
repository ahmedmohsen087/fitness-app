import 'package:fitness_app/core/reusable_widgets/custom_media_card.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/section_app/widgets/workouts_filter_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UpcomingWorkoutsWidget extends StatefulWidget {
  const UpcomingWorkoutsWidget({super.key});

  @override
  State<UpcomingWorkoutsWidget> createState() => _UpcomingWorkoutsWidgetState();
}

class _UpcomingWorkoutsWidgetState extends State<UpcomingWorkoutsWidget> {
  String? _selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        WorkoutsFilterTabs(
          selectedMuscleGroupId: _selectedGroupId,
          onFullBodyTap: () => setState(() => _selectedGroupId = null),
          onGroupTap: (id) => setState(() => _selectedGroupId = id),
        ),
        _buildMediaCardsList(),
      ],
    );
  }

  Widget _buildMediaCardsList() {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final isFullBody = _selectedGroupId == null;
        final isLoading = _getIsLoading(state, isFullBody);
        final muscles = _getMuscles(state, isFullBody);

        return SizedBox(
          height: 110,
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading ? 5 : muscles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) =>
                  _buildItem(context, isLoading, muscles, index),
            ),
          ),
        );
      },
    );
  }

  bool _getIsLoading(FitnessState state, bool isFullBody) {
    return isFullBody
        ? state.recommendationToDayState.isLoading
        : state.musclesByGroupState.isLoading;
  }

  List<MuscleEntity> _getMuscles(FitnessState state, bool isFullBody) {
    if (isFullBody) {
      return state.recommendationToDayState.data ?? [];
    }
    return state.musclesByGroupState.data ?? [];
  }

  Widget _buildItem(
    BuildContext context,
    bool isLoading,
    List<MuscleEntity> muscles,
    int index,
  ) {
    if (isLoading) {
      return const CustomMediaCard(
        width: 90,
        height: 110,
        image: '',
        title: '...',
      );
    }

    final muscle = muscles[index];
    return CustomMediaCard(
      width: 90,
      height: 110,
      image: muscle.image,
      title: muscle.name,
      onTap: () => _navigateToExercise(context, muscle),
    );
  }

  void _navigateToExercise(BuildContext context, MuscleEntity muscle) {
    Navigator.pushNamed(
      context,
      AppRoutsName.exercise,
      arguments: ExerciseScreenArgs(
        primeMoverMuscleId: muscle.id,
        muscleName: muscle.name,
        image: muscle.image,
      ),
    );
  }
}
