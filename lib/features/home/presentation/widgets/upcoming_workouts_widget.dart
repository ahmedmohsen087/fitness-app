import 'package:fitness_app/core/reusable_widgets/custom_media_card.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UpcomingWorkoutsWidget extends StatelessWidget {
  const UpcomingWorkoutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final isLoading = state.musclesByGroupState.isLoading;
        final muscles = state.musclesByGroupState.data ?? [];

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

                final muscle = muscles[index];

                return CustomMediaCard(
                  width: 90,
                  height: 110,
                  image: muscle.image,
                  title: muscle.name,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
