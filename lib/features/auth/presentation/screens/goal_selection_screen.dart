import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/register_option_tile.dart';
import '../widgets/register_step_scaffold.dart';

class GoalSelectionScreen extends StatelessWidget {
  final VoidCallback onBack;

  const GoalSelectionScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return RegisterStepScaffold(
      step: 5,
      title: AppStrings.whatIsYourGoal,
      subtitle: AppStrings.personalizedPlanSubtitle,
      onBack: onBack,
      child: const _GoalContent(),
    );
  }
}

class _GoalContent extends StatelessWidget {
  const _GoalContent();

  @override
  Widget build(BuildContext context) {
    final options = [
      (FitnessGoal.gainWeight, AppStrings.goalGainWeight),
      (FitnessGoal.loseWeight, AppStrings.goalLoseWeight),
      (FitnessGoal.getFitter, AppStrings.goalGetFitter),
      (FitnessGoal.gainMoreFlexible, AppStrings.goalGainMoreFlexible),
      (FitnessGoal.learnTheBasic, AppStrings.goalLearnTheBasic),
    ];

    return BlocBuilder<RegisterViewModel, RegisterState>(
      buildWhen: (previous, current) => previous.goal != current.goal,
      builder: (context, state) {
        return Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              RegisterOptionTile(
                label: options[index].$2,
                selected: state.goal == options[index].$1,
                onTap: () => context.read<RegisterViewModel>().doEvent(
                  SelectGoalEvent(goal: options[index].$1),
                ),
              ),
              if (index != options.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: AppStrings.next,
              onPressed: state.goal == null
                  ? null
                  : () => context.read<RegisterViewModel>().doEvent(
                      const ContinueRegistrationEvent(
                        target: RegisterFlowStep.activity,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
