import 'package:fitness_app/features/home/presentation/widgets/recommendation_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/values/app_routs_name.dart';
import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';

class RecommendationForYouWidget extends StatelessWidget {
  const RecommendationForYouWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final isLoading = state.recommendationFoodState.isLoading;
        final recommendations =
            state.recommendationFoodState.data?.categories ?? [];

        return SizedBox(
          height: 104,
          child: Skeletonizer(
            enabled: isLoading,
            enableSwitchAnimation: true,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading ? 5 : recommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 20),
              itemBuilder: (_, index) {
                if (isLoading) {
                  return const RecommendationItemWidget(
                    image:
                        'https://www.themealdb.com/images/category/chicken.png',
                    title: 'Loading',
                  );
                }
                final item = recommendations[index];
                return RecommendationItemWidget(
                  image: item.strCategoryThumb,
                  title: item.strCategory,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutsName.food,
                    arguments: item.strCategory,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
