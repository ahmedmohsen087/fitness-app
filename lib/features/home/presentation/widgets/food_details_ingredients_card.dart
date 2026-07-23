import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/food_details/meal_details_entity.dart';

class FoodDetailsIngredientsCard extends StatelessWidget {
  final MealDetailsEntity meal;

  const FoodDetailsIngredientsCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlack.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          for (var index = 0; index < meal.ingredients.length; index++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.ingredients[index].name,
                      style: TextStyles.authSubtitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (meal.ingredients[index].measure.isNotEmpty)
                    Text(
                      meal.ingredients[index].measure,
                      textAlign: TextAlign.end,
                      style: TextStyles.authField.copyWith(
                        color: AppColors.orange,
                      ),
                    ),
                ],
              ),
            ),
            if (index < meal.ingredients.length - 1)
              Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.08)),
          ],
        ],
      ),
    );
  }
}
