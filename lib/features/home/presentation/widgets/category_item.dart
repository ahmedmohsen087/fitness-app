import 'package:fitness_app/features/home/presentation/widgets/category_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      CategoryModel(
        image: Assets.gymLogo,
        title: AppStrings.gym,
      ),
      CategoryModel(
        image: Assets.fitnessLogo,
        title: AppStrings.fitness,
      ),
      CategoryModel(
        image: Assets.yogaLogo,
        title: AppStrings.yoga,
      ),
      CategoryModel(
        image: Assets.aerobicsLogo,
        title: AppStrings.aerobics,
      ),
      CategoryModel(
        image: Assets.trainerLogo,
        title: AppStrings.trainer,
      ),
    ];

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.lightBlack.withValues(alpha: .80),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(

          child: VerticalDivider(
            color: AppColors.lightGray,
            thickness: .5,
            indent: 10,
            endIndent: 10,
          ),
        ),
        itemBuilder: (context, index) {
          final item = categories[index];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: CategoryModel(
              image: item.image,
              title: item.title,
            ),
          );
        },
      ),
    );
  }
}
