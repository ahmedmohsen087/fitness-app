import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../view_models/home_events.dart';
import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';
import '../widgets/food_details_content.dart';
import '../widgets/food_details_message_state.dart';

class FoodDetailsScreen extends StatelessWidget {
  final String mealId;

  const FoodDetailsScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HomeViewModel>()..doEvent(LoadMealDetailsEvent(mealId)),
      child: const _FoodDetailsView(),
    );
  }
}

class _FoodDetailsView extends StatelessWidget {
  const _FoodDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeViewModel, HomeState>(
      listenWhen: (previous, current) =>
          previous.mealDetailsState.msg != current.mealDetailsState.msg,
      listener: (context, state) {
        final message = state.mealDetailsState.msg;
        if (message != null) AppToast.error(context, message);
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBlack,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(Assets.homeBackGround, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: ColoredBox(color: AppColors.black.withValues(alpha: 0.5)),
            ),
            BlocBuilder<HomeViewModel, HomeState>(
              buildWhen: (previous, current) =>
                  previous.mealDetailsState != current.mealDetailsState,
              builder: (context, state) {
                if (state.mealDetailsState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final message = state.mealDetailsState.msg;
                if (message != null) {
                  return FoodDetailsMessageState(message: message);
                }

                final meals = state.mealDetailsState.data?.meals ?? const [];
                if (meals.isEmpty) {
                  return FoodDetailsMessageState(
                    message: AppStrings.noMealDetails,
                  );
                }

                return FoodDetailsContent(meal: meals.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
