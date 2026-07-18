import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/gender_option_widget.dart';
import '../widgets/register_step_scaffold.dart';

class GenderSelectionScreen extends StatelessWidget {
  final VoidCallback onBack;

  const GenderSelectionScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return RegisterStepScaffold(
      step: 1,
      title: AppStrings.tellUsAboutYourself,
      subtitle: AppStrings.weNeedToKnowYourGender,
      onBack: onBack,
      child: const _GenderContent(),
    );
  }
}

class _GenderContent extends StatelessWidget {
  const _GenderContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterViewModel, RegisterState>(
      buildWhen: (previous, current) => previous.gender != current.gender,
      builder: (context, state) {
        return Column(
          children: [
            Column(
              children: [
                GenderOptionWidget(
                  label: AppStrings.male,
                  icon: Icons.male,
                  isSelected: state.gender == Gender.male,
                  onTap: () => context.read<RegisterViewModel>().doEvent(
                    const SelectGenderEvent(gender: Gender.male),
                  ),
                ),
                const SizedBox(height: 24),
                GenderOptionWidget(
                  label: AppStrings.female,
                  icon: Icons.female,
                  isSelected: state.gender == Gender.female,
                  onTap: () => context.read<RegisterViewModel>().doEvent(
                    const SelectGenderEvent(gender: Gender.female),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: AppStrings.next,
              onPressed: state.gender == null
                  ? null
                  : () => context.read<RegisterViewModel>().doEvent(
                      const ContinueRegistrationEvent(
                        target: RegisterFlowStep.age,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
