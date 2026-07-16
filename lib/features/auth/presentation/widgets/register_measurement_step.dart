import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import 'auth_primary_button.dart';
import 'register_flow_listener.dart';
import 'register_number_picker.dart';
import 'register_step_scaffold.dart';

class RegisterMeasurementStep extends StatelessWidget {
  final RegisterViewModel viewModel;
  final int step;
  final String title;
  final String subtitle;
  final String unit;
  final String buttonLabel;
  final int min;
  final int max;
  final int Function(RegisterState state) valueOf;
  final RegisterEvents Function(int value) updateEvent;
  final RegisterFlowStep nextStep;

  const RegisterMeasurementStep({
    super.key,
    required this.viewModel,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.unit,
    required this.buttonLabel,
    required this.min,
    required this.max,
    required this.valueOf,
    required this.updateEvent,
    required this.nextStep,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: RegisterFlowListener(
        child: RegisterStepScaffold(
          step: step,
          title: title,
          subtitle: subtitle,
          child: BlocBuilder<RegisterViewModel, RegisterState>(
            buildWhen: (previous, current) =>
                valueOf(previous) != valueOf(current),
            builder: (context, state) {
              return Column(
                children: [
                  RegisterNumberPicker(
                    min: min,
                    max: max,
                    value: valueOf(state),
                    unit: unit,
                    onChanged: (value) => context
                        .read<RegisterViewModel>()
                        .doEvent(updateEvent(value)),
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    label: buttonLabel,
                    onPressed: () => context.read<RegisterViewModel>().doEvent(
                      ContinueRegistrationEvent(target: nextStep),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
