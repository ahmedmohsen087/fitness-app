import 'package:flutter/material.dart';

import '../../../../core/reusable_widgets/app_video_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../domain/entities/food_details/meal_details_entity.dart';
import 'food_details_ingredients_card.dart';

class FoodDetailsContent extends StatelessWidget {
  final MealDetailsEntity meal;

  const FoodDetailsContent({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _DetailsHero(meal: meal)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          sliver: SliverList.list(
            children: [
              Text(AppStrings.ingredients, style: TextStyles.authHeadline),
              const SizedBox(height: 8),
              FoodDetailsIngredientsCard(meal: meal),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsHero extends StatelessWidget {
  final MealDetailsEntity meal;

  const _DetailsHero({required this.meal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 344,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              meal.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: AppColors.lightBlack,
                child: Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.lightGray,
                  size: 64,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.lightBlack],
                  stops: [0.28, 1],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, top: 12),
                  child: Semantics(
                    button: true,
                    label: AppStrings.back,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.maybePop(context),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.orange,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 12,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (meal.youtubeUrl.isNotEmpty)
              Center(
                child: Semantics(
                  button: true,
                  label: AppStrings.recipeVideo,
                  child: Material(
                    color: AppColors.black.withValues(alpha: 0.52),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: AppColors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => AppVideoDialog.show(
                        context,
                        youtubeUrl: meal.youtubeUrl,
                        title: meal.name,
                      ),
                      child: const SizedBox.square(
                        dimension: 64,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.orange,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.authTitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (meal.instructions.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        meal.instructions.replaceAll(RegExp(r'\s+'), ' '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.authSubtitle,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _MetadataRow(meal: meal),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final MealDetailsEntity meal;

  const _MetadataRow({required this.meal});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      if (meal.category.isNotEmpty) (meal.category, AppStrings.category),
      if (meal.area.isNotEmpty) (meal.area, AppStrings.cuisine),
      if (meal.country.isNotEmpty) (meal.country, AppStrings.country),
      if (meal.tags.isNotEmpty) (meal.tags.first, AppStrings.tags),
    ];

    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: _MetadataPill(
              value: items[index].$1,
              label: items[index].$2,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetadataPill extends StatelessWidget {
  final String value;
  final String label;

  const _MetadataPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.55)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.authField.copyWith(color: AppColors.white),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.authOption.copyWith(color: AppColors.orange),
          ),
        ],
      ),
    );
  }
}
