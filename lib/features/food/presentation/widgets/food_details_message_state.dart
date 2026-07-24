import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../view_model/food_events.dart';
import '../view_model/food_view_model.dart';

class FoodDetailsMessageState extends StatelessWidget {
  final String message;

  const FoodDetailsMessageState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topStart,
            child: IconButton(
              tooltip: AppStrings.back,
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.white,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyles.authSubtitle,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<FoodViewModel>().doEvent(
                    RetryMealDetailsEvent(),
                  ),
                  child: Text(AppStrings.retry),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
