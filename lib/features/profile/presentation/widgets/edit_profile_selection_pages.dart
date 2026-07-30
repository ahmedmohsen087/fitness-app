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

class EditProfileSelectionPage extends StatelessWidget {
  final EditProfilePage page;

  const EditProfileSelectionPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return RegisterStepScaffold(
      step: 0,
      mode: ProfileSelectionMode.editProfile,
      title: switch (page) {
        EditProfilePage.weight => AppStrings.whatIsYourWeight,
        EditProfilePage.goal => AppStrings.whatIsYourGoal,
        EditProfilePage.activity => AppStrings.regularPhysicalActivity,
        EditProfilePage.details => '',
      },
      subtitle: page == EditProfilePage.activity
          ? ''
          : AppStrings.personalizedPlanSubtitle,
      onBack: () => _showDetails(context),
      child: switch (page) {
        EditProfilePage.weight => const _WeightSelectionContent(),
        EditProfilePage.goal => const _GoalSelectionContent(),
        EditProfilePage.activity => const _ActivitySelectionContent(),
        EditProfilePage.details => const SizedBox.shrink(),
      },
    );
  }

  void _showDetails(BuildContext context) {
    context.read<EditProfileViewModel>().doEvent(
      const ChangeEditProfilePageEvent(page: EditProfilePage.details),
    );
  }
}

class _WeightSelectionContent extends StatelessWidget {
  const _WeightSelectionContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileViewModel, EditProfileState>(
      buildWhen: (previous, current) => previous.weight != current.weight,
      builder: (context, state) {
        return Column(
          children: [
            RegisterNumberPicker(
              min: RegisterConstants.minimumWeight,
              max: RegisterConstants.maximumWeight,
              value: state.weight ?? RegisterConstants.defaultWeight,
              unit: AppStrings.kilogram,
              onChanged: (weight) {
                context.read<EditProfileViewModel>().doEvent(
                  UpdateEditWeightEvent(weight: weight),
                );
              },
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: AppStrings.done,
              onPressed: () => _showDetails(context),
            ),
          ],
        );
      },
    );
  }
}

class _GoalSelectionContent extends StatelessWidget {
  const _GoalSelectionContent();

  @override
  Widget build(BuildContext context) {
    final options = [
      (FitnessGoal.gainWeight, AppStrings.goalGainWeight),
      (FitnessGoal.loseWeight, AppStrings.goalLoseWeight),
      (FitnessGoal.getFitter, AppStrings.goalGetFitter),
      (FitnessGoal.gainMoreFlexible, AppStrings.goalGainMoreFlexible),
      (FitnessGoal.learnTheBasic, AppStrings.goalLearnTheBasic),
    ];

    return BlocBuilder<EditProfileViewModel, EditProfileState>(
      buildWhen: (previous, current) => previous.goal != current.goal,
      builder: (context, state) {
        return Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              RegisterOptionTile(
                label: options[index].$2,
                selected: state.goal == options[index].$1,
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
              onPressed: state.goal == null
                  ? null
                  : () => _showDetails(context),
            ),
          ],
        );
      },
    );
  }
}

class _ActivitySelectionContent extends StatelessWidget {
  const _ActivitySelectionContent();

  @override
  Widget build(BuildContext context) {
    final options = [
      (ActivityLevel.level1, AppStrings.activityLevelRookie),
      (ActivityLevel.level2, AppStrings.activityLevelBeginner),
      (ActivityLevel.level3, AppStrings.activityLevelIntermediate),
      (ActivityLevel.level4, AppStrings.activityLevelAdvance),
      (ActivityLevel.level5, AppStrings.activityLevelTrueBeast),
    ];

    return BlocBuilder<EditProfileViewModel, EditProfileState>(
      buildWhen: (previous, current) =>
          previous.activityLevel != current.activityLevel,
      builder: (context, state) {
        return Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              RegisterOptionTile(
                label: options[index].$2,
                selected: state.activityLevel == options[index].$1,
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
              onPressed: state.activityLevel == null
                  ? null
                  : () => _showDetails(context),
            ),
          ],
        );
      },
    );
  }
}

void _showDetails(BuildContext context) {
  context.read<EditProfileViewModel>().doEvent(
    const ChangeEditProfilePageEvent(page: EditProfilePage.details),
  );
}
