import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../view_model/food_events.dart';
import '../view_model/food_state.dart';
import '../view_model/food_view_model.dart';
import '../widgets/food_category_tabs.dart';
import '../widgets/meal_card.dart';

class FoodScreen extends StatelessWidget {
  final String? initialCategory;

  const FoodScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return BlocProvider(
      create: (_) =>
          getIt<FoodViewModel>()
            ..doEvent(LoadFoodDataEvent(initialCategory: initialCategory)),
      child: const _FoodView(),
    );
  }
}

class _FoodView extends StatelessWidget {
  const _FoodView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodViewModel, FoodState>(
      listenWhen: (previous, current) =>
          previous.categoriesState.msg != current.categoriesState.msg ||
          previous.mealsState.msg != current.mealsState.msg,
      listener: (context, state) {
        final message = state.categoriesState.msg ?? state.mealsState.msg;
        if (message != null) AppToast.error(context, message);
      },
      child: AppBackgroundScaffold(
        imagePath: Assets.mainBackground,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FoodHeader(),
              const SizedBox(height: 24),
              const FoodCategoryTabs(),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<FoodViewModel, FoodState>(
                  buildWhen: (previous, current) =>
                      previous.categoriesState !=
                          current.categoriesState ||
                      previous.mealsState != current.mealsState,
                  builder: (context, state) => _FoodContent(state: state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodHeader extends StatelessWidget {
  const _FoodHeader();

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return SizedBox(
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Semantics(
              button: true,
              label: AppStrings.back,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.maybePop(context),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.orange,
                  child: Icon(
                    isRtl
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          Text(
            AppStrings.foodRecommendation,
            style: TextStyles.authTitle.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodContent extends StatelessWidget {
  final FoodState state;

  const _FoodContent({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.categoriesState.isLoading ||
        (state.mealsState.isLoading && state.mealsState.data == null)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categoriesState.msg != null || state.mealsState.msg != null) {
      return _MessageState(
        message: state.categoriesState.msg ?? state.mealsState.msg ?? '',
        onRetry: () =>
            context.read<FoodViewModel>().doEvent(RetryFoodDataEvent()),
      );
    }

    final categories = state.categoriesState.data?.categories ?? const [];
    if (categories.isEmpty) {
      return _MessageState(message: AppStrings.noFoodCategories);
    }

    final meals = state.mealsState.data?.meals ?? const [];
    if (meals.isEmpty) {
      return _MessageState(message: AppStrings.noMealsFound);
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 17,
        crossAxisSpacing: 16,
        mainAxisExtent: 160,
      ),
      itemCount: meals.length,
      itemBuilder: (context, index) => MealCard(
        meal: meals[index],
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutsName.foodDetails,
          arguments: meals[index].id,
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _MessageState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyles.authSubtitle,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(AppStrings.retry)),
          ],
        ],
      ),
    );
  }
}
