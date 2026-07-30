import 'package:fitness_app/core/reusable_widgets/custom_media_card.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecommendationToDay extends StatelessWidget {
  const RecommendationToDay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final isLoading = state.recommendationToDayState.isLoading;
        final muscles = state.recommendationToDayState.data ?? [];

        return SizedBox(
          height: 110,
          child: Skeletonizer(
            enabled: isLoading && muscles.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading && muscles.isEmpty ? 5 : muscles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                if (isLoading && muscles.isEmpty) {
                  return const CustomMediaCard(
                    width: 90,
                    height: 110,
                    image: '',
                    title: '...',
                  );
                }

                return _buildCard(context, muscles[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, MuscleEntity muscle) {
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
