import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/register_option_tile.dart';
import '../widgets/register_step_scaffold.dart';

class ActivitySelectionScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ActivitySelectionScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterViewModel, RegisterState>(
      listenWhen: (previous, current) =>
          previous.submitState != current.submitState &&
          !current.submitState.isLoading,
      listener: (context, state) {
        final error = state.submitState.msg;
        if (error != null) {
          AppToast.error(context, error);
          return;
        }

        if (state.submitState.data != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutsName.sectionApp,
            (_) => false,
          );
        }
      },
      child: RegisterStepScaffold(
        step: 6,
        title: AppStrings.regularPhysicalActivity,
        subtitle: '',
        onBack: onBack,
        child: const _ActivityContent(),
      ),
    );
  }
}

class _ActivityContent extends StatelessWidget {
  const _ActivityContent();

  @override
  Widget build(BuildContext context) {
    final options = [
      (ActivityLevel.level1, AppStrings.activityLevelRookie),
      (ActivityLevel.level2, AppStrings.activityLevelBeginner),
      (ActivityLevel.level3, AppStrings.activityLevelIntermediate),
      (ActivityLevel.level4, AppStrings.activityLevelAdvance),
      (ActivityLevel.level5, AppStrings.activityLevelTrueBeast),
    ];

    return BlocBuilder<RegisterViewModel, RegisterState>(
      buildWhen: (previous, current) =>
          previous.activityLevel != current.activityLevel ||
          previous.submitState.isLoading != current.submitState.isLoading,
      builder: (context, state) {
        return Column(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              RegisterOptionTile(
                label: options[index].$2,
                selected: state.activityLevel == options[index].$1,
                onTap: () => context.read<RegisterViewModel>().doEvent(
                  SelectActivityLevelEvent(activityLevel: options[index].$1),
                ),
              ),
              if (index != options.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: AppStrings.next,
              isLoading: state.submitState.isLoading,
              onPressed: state.activityLevel == null
                  ? null
                  : () => context.read<RegisterViewModel>().doEvent(
                      const SubmitRegisterEvent(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
