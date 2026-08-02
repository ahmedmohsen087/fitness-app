import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../../../auth/presentation/widgets/auth_primary_button.dart';
import '../../../auth/presentation/widgets/register_number_picker.dart';
import '../../../auth/presentation/widgets/register_option_tile.dart';
import '../../../auth/presentation/widgets/register_step_scaffold.dart';
import '../view_models/edit_profile_view_models/edit_profile_events.dart';
import '../view_models/edit_profile_view_models/edit_profile_states.dart';
import '../view_models/edit_profile_view_models/edit_profile_view_model.dart';

enum EditProfilePage { weight, goal, activity }

class EditProfileSelectionPage extends StatelessWidget {
  final EditProfilePage page;
  final VoidCallback onClose;

  const EditProfileSelectionPage({
    super.key,
    required this.page,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return RegisterStepScaffold(
      step: 0,
      mode: ProfileSelectionMode.editProfile,
      title: switch (page) {
        EditProfilePage.weight => AppStrings.whatIsYourWeight,
        EditProfilePage.goal => AppStrings.whatIsYourGoal,
        EditProfilePage.activity => AppStrings.regularPhysicalActivity,
      },
      subtitle: page == EditProfilePage.activity
          ? ''
          : AppStrings.personalizedPlanSubtitle,
      onBack: onClose,
      child: switch (page) {
        EditProfilePage.weight => _WeightSelectionContent(onDone: onClose),
        EditProfilePage.goal => _GoalSelectionContent(onDone: onClose),
        EditProfilePage.activity => _ActivitySelectionContent(onDone: onClose),
      },
    );
  }
}

class _WeightSelectionContent extends StatelessWidget {
  final VoidCallback onDone;

  const _WeightSelectionContent({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditProfileViewModel, EditProfileState, int?>(
      selector: (state) => state.weight,
      builder: (context, weight) {
        return Column(
          children: [
            RegisterNumberPicker(
              min: RegisterConstants.minimumWeight,
              max: RegisterConstants.maximumWeight,
              value: weight ?? RegisterConstants.defaultWeight,
              unit: AppStrings.kilogram,
              onChanged: (weight) {
                context.read<EditProfileViewModel>().doEvent(
                  UpdateEditWeightEvent(weight: weight),
                );
              },
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(label: AppStrings.done, onPressed: onDone),
          ],
        );
      },
    );
  }
}

class _GoalSelectionContent extends StatelessWidget {
  final VoidCallback onDone;

  const _GoalSelectionContent({required this.onDone});

  @override
  Widget build(BuildContext context) {
    final options = [
      (FitnessGoal.gainWeight, AppStrings.goalGainWeight),
      (FitnessGoal.loseWeight, AppStrings.goalLoseWeight),
      (FitnessGoal.getFitter, AppStrings.goalGetFitter),
      (FitnessGoal.gainMoreFlexible, AppStrings.goalGainMoreFlexible),
      (FitnessGoal.learnTheBasic, AppStrings.goalLearnTheBasic),
    ];

    return BlocSelector<EditProfileViewModel, EditProfileState, FitnessGoal?>(
      selector: (state) => state.goal,
      builder: (context, goal) {
        return Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              RegisterOptionTile(
                label: options[index].$2,
                selected: goal == options[index].$1,
                onTap: () {
                  context.read<EditProfileViewModel>().doEvent(
                    SelectEditGoalEvent(goal: options[index].$1),
                  );
                },
              ),
              if (index != options.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: AppStrings.done,
              onPressed: goal == null ? null : onDone,
            ),
          ],
        );
      },
    );
  }
}

class _ActivitySelectionContent extends StatelessWidget {
  final VoidCallback onDone;

  const _ActivitySelectionContent({required this.onDone});

  @override
  Widget build(BuildContext context) {
    final options = [
      (ActivityLevel.level1, AppStrings.activityLevelRookie),
      (ActivityLevel.level2, AppStrings.activityLevelBeginner),
      (ActivityLevel.level3, AppStrings.activityLevelIntermediate),
      (ActivityLevel.level4, AppStrings.activityLevelAdvance),
      (ActivityLevel.level5, AppStrings.activityLevelTrueBeast),
    ];

    return BlocSelector<EditProfileViewModel, EditProfileState, ActivityLevel?>(
      selector: (state) => state.activityLevel,
      builder: (context, activityLevel) {
        return Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              RegisterOptionTile(
                label: options[index].$2,
                selected: activityLevel == options[index].$1,
                onTap: () {
                  context.read<EditProfileViewModel>().doEvent(
                    SelectEditActivityLevelEvent(
                      activityLevel: options[index].$1,
                    ),
                  );
                },
              ),
              if (index != options.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: AppStrings.done,
              onPressed: activityLevel == null ? null : onDone,
            ),
          ],
        );
      },
    );
  }
}
