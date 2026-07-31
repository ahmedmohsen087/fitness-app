import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/features/home/presentation/widgets/category_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    final categories = [
      CategoryModel(image: Assets.gymAvatar, title: AppStrings.gym),
      CategoryModel(image: Assets.fitnessAvatar, title: AppStrings.fitness),
      CategoryModel(image: Assets.yogaAvatar, title: AppStrings.yoga),
      CategoryModel(image: Assets.aerobicsAvatar, title: AppStrings.aerobics),
      CategoryModel(image: Assets.trainerAvatar, title: AppStrings.trainer),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.lightBlack.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(categories.length, (index) {
          final item = categories[index];
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CategoryModel(image: item.image, title: item.title),
                ),
                if (index < categories.length - 1)
                  const SizedBox(
                    height: 36,
                    child: VerticalDivider(
                      color: AppColors.lightGray,
                      thickness: 0.5,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
