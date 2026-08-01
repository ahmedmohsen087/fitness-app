import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/chat_action_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';

class SmartCoachActionCardWidget extends StatelessWidget {
  final ChatActionEntity action;

  static final RegExp _objectIdRegex = RegExp(r'[a-fA-F0-9]{24}');

  const SmartCoachActionCardWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    if (action.type == SmartCoachActionType.none) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (action.title.isNotEmpty)
            Text(
              action.title,
              style: TextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _handleNavigation(context),
              child: Text(
                AppStrings.goToDetails,
                style: TextStyles.buttonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context) {
    switch (action.type) {
      case SmartCoachActionType.navigateFoodDetails:
        final mealId = action.params.mealId ?? '';
        if (mealId.isNotEmpty) {
          Navigator.pushNamed(
            context,
            AppRoutsName.foodDetails,
            arguments: mealId,
          );
        }
        break;
      case SmartCoachActionType.navigateExercise:
        var exerciseId = action.params.exerciseId ?? '';
        final muscleName = action.params.muscleName ?? action.title;
        final image = action.params.image ?? '';

        final match = _objectIdRegex.firstMatch(exerciseId);
        if (match != null) {
          exerciseId = match.group(0)!;
        }

        if (exerciseId.isNotEmpty) {
          final args = ExerciseScreenArgs(
            primeMoverMuscleId: exerciseId,
            muscleName: muscleName,
            image: image,
          );
          Navigator.pushNamed(context, AppRoutsName.exercise, arguments: args);
        }
        break;
      case SmartCoachActionType.navigateWorkouts:
      case SmartCoachActionType.none:
        break;
    }
  }
}
