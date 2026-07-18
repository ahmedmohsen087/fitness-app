import 'package:fitness_app/features/home/presentation/widgets/recommendation_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';

class UpcomingWorkoutsWidget extends StatelessWidget {
  const UpcomingWorkoutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();

    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoadingState;
        final muscles = viewModel.musclesGroupById?.muscles ?? [];

        return SizedBox(
          height: 90,
          child: Skeletonizer(
            enabled: isLoading && muscles.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading && muscles.isEmpty ? 5 : muscles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 20),
              itemBuilder: (_, index) {
                if (isLoading && muscles.isEmpty) {
                  return const RecommendationItemWidget(
                    width: 80,
                    height: 80,
                    image: 'https://iili.io/33p7ww7.png',
                    title: 'Loading',
                  );
                }

                final muscle = muscles[index];

                return RecommendationItemWidget(
                  width: 80,
                  height: 80,
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