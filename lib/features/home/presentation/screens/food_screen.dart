import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_bottom_nav_bar.dart';
import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../view_models/home_events.dart';
import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';
import '../widgets/food_category_tabs.dart';
import '../widgets/meal_card.dart';

class FoodScreen extends StatelessWidget {
  final String? initialCategory;

  const FoodScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HomeViewModel>()
            ..doEvent(LoadFoodDataEvent(initialCategory: initialCategory)),
      child: const _FoodView(),
    );
  }
}

class _FoodView extends StatelessWidget {
  const _FoodView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeViewModel, HomeState>(
      listenWhen: (previous, current) =>
          previous.recommendationFoodState.msg !=
              current.recommendationFoodState.msg ||
          previous.mealsState.msg != current.mealsState.msg,
      listener: (context, state) {
        final message =
            state.recommendationFoodState.msg ?? state.mealsState.msg;
        if (message != null) AppToast.error(context, message);
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.lightBlack,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 0,
          onTap: (index) => _onNavigationTap(context, index),
          items: [
            AppBottomNavItem(icon: Assets.homeIcon, label: AppStrings.home),
            AppBottomNavItem(icon: Assets.chatIcon, label: AppStrings.chat),
            AppBottomNavItem(
              icon: Assets.workoutsIcon,
              label: AppStrings.workouts,
            ),
            AppBottomNavItem(
              icon: Assets.profileIcon,
              label: AppStrings.profile,
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(Assets.homeBackGround, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: ColoredBox(color: AppColors.black.withValues(alpha: 0.50)),
            ),
            SafeArea(
              bottom: false,
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
                      child: BlocBuilder<HomeViewModel, HomeState>(
                        buildWhen: (previous, current) =>
                            previous.recommendationFoodState !=
                                current.recommendationFoodState ||
                            previous.mealsState != current.mealsState,
                        builder: (context, state) => _FoodContent(state: state),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigationTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.maybePop(context);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutsName.sectionApp,
      (_) => false,
      arguments: index,
    );
  }
}

class _FoodHeader extends StatelessWidget {
  const _FoodHeader();

  @override
  Widget build(BuildContext context) {
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
  final HomeState state;

  const _FoodContent({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.recommendationFoodState.isLoading ||
        (state.mealsState.isLoading && state.mealsState.data == null)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.recommendationFoodState.msg != null ||
        state.mealsState.msg != null) {
      return _MessageState(
        message:
            state.recommendationFoodState.msg ?? state.mealsState.msg ?? '',
        onRetry: () =>
            context.read<HomeViewModel>().doEvent(RetryFoodDataEvent()),
      );
    }

    final categories =
        state.recommendationFoodState.data?.categories ?? const [];
    if (categories.isEmpty) {
      return _MessageState(message: AppStrings.noFoodCategories);
    }

    final meals = state.mealsState.data?.meals ?? const [];
    if (meals.isEmpty) {
      return _MessageState(message: AppStrings.noMealsFound);
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 112),
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
