import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../view_models/home_events.dart';
import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';

class FoodCategoryTabs extends StatelessWidget {
  const FoodCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.recommendationFoodState != current.recommendationFoodState ||
          previous.selectedFoodCategory != current.selectedFoodCategory,
      builder: (context, state) {
        final categories =
            state.recommendationFoodState.data?.categories ?? const [];

        return SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index].strCategory;
              final selected = category == state.selectedFoodCategory;

              return Semantics(
                button: true,
                selected: selected,
                label: category,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: state.mealsState.isLoading && selected
                      ? null
                      : () => context.read<HomeViewModel>().doEvent(
                          SelectFoodCategoryEvent(category),
                        ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.orange : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyles.authField.copyWith(
                        color: selected ? AppColors.white : AppColors.lightGray,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
