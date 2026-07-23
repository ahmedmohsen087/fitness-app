import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';
import 'recommendation_item_widget.dart';

class RecommendationToDay extends StatelessWidget {
  const RecommendationToDay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final isLoading = state.recommendationToDayState.isLoading;

        final muscles = state.recommendationToDayState.data?.muscles ?? [];

        return SizedBox(
          height: 104,
          child: Skeletonizer(
            enableSwitchAnimation: true,
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading ? 5 : muscles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                if (isLoading) {
                  return const RecommendationItemWidget(
                    image: 'https://iili.io/33pY9AN.png',
                    title: 'Loading',
                  );
                }

                final muscle = muscles[index];

                return RecommendationItemWidget(
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
