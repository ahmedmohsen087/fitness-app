import 'package:fitness_app/core/reusable_widgets/custom_media_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/base_state/base_state.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../food/domain/entities/category_food/category_food_entity.dart';
import '../../../food/domain/entities/category_food/recommendation_food_entity.dart';
import '../view_models/home_events.dart';
import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';

class RecommendationForYouWidget extends StatelessWidget {
  const RecommendationForYouWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.recommendationFoodState != current.recommendationFoodState,
      builder: (context, state) => _RecommendationContent(
        recommendationState: state.recommendationFoodState,
      ),
    );
  }
}

class _RecommendationContent extends StatelessWidget {
  final BaseState<RecommendationFoodEntity> recommendationState;

  const _RecommendationContent({required this.recommendationState});

  @override
  Widget build(BuildContext context) {
    if (recommendationState.msg != null) {
      return _RecommendationError(
        message: recommendationState.msg ?? AppStrings.somethingWentWrong,
      );
    }
    return _RecommendationList(
      isLoading: recommendationState.isLoading,
      recommendations: recommendationState.data?.categories ?? const [],
    );
  }
}

class _RecommendationList extends StatelessWidget {
  final bool isLoading;
  final List<CategoryFoodEntity> recommendations;

  const _RecommendationList({
    required this.isLoading,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Skeletonizer(
        enabled: isLoading && recommendations.isEmpty,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: isLoading && recommendations.isEmpty ? 5 : recommendations.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, index) => _buildItem(context, index),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (isLoading && recommendations.isEmpty) {
      return const CustomMediaCard(
        width: 90,
        height: 110,
        image: '',
        title: '...',
      );
    }
    final item = recommendations[index];
    return CustomMediaCard(
      width: 90,
      height: 110,
      image: item.strCategoryThumb,
      title: item.strCategory,
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutsName.food,
        arguments: item.strCategory,
      ),
    );
  }
}

class _RecommendationError extends StatelessWidget {
  final String message;

  const _RecommendationError({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.authField,
            ),
            TextButton(
              onPressed: () =>
                  context.read<HomeViewModel>().doEvent(RetryHomeDataEvent()),
              child: Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
