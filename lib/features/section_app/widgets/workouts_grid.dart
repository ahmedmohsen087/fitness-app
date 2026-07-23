import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_states.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_view_models.dart';
import 'package:fitness_app/features/section_app/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef _WorkoutItem = ({String id, String name, String image});

class WorkoutsGrid extends StatelessWidget {
  final String? selectedMuscleGroupId;

  const WorkoutsGrid({super.key, required this.selectedMuscleGroupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final isFullBody = selectedMuscleGroupId == null;

        final isLoading = isFullBody
            ? state.recommendationToDayState.isLoading
            : state.musclesGroupByIdState.isLoading;

        final List<_WorkoutItem> workouts = isFullBody
            ? state.recommendationToDayState.data?.muscles
                      .map((e) => (id: e.id, name: e.name, image: e.image))
                      .toList() ??
                  []
            : state.musclesGroupByIdState.data?.muscles
                      .map((e) => (id: e.id, name: e.name, image: e.image))
                      .toList() ??
                  [];

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
              return WorkoutCard(image: workout.image, title: workout.name);
            },
          ),
        );
      },
    );
  }
}
