import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../view_model/food_events.dart';
import '../view_model/food_state.dart';
import '../view_model/food_view_model.dart';

class FoodCategoryTabs extends StatelessWidget {
  const FoodCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodViewModel, FoodState>(
      buildWhen: (previous, current) =>
          previous.categoriesState != current.categoriesState ||
          previous.selectedCategory != current.selectedCategory,
      builder: (context, state) {
        final categories = state.categoriesState.data?.categories ?? const [];

        return SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index].strCategory;
              final selected = category == state.selectedCategory;

              return Semantics(
                button: true,
                selected: selected,
                label: category,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: state.mealsState.isLoading && selected
                      ? null
                      : () => context.read<FoodViewModel>().doEvent(
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
