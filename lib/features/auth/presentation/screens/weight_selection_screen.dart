import 'package:flutter/material.dart';

import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import '../widgets/register_measurement_step.dart';

class WeightSelectionScreen extends StatelessWidget {
  final RegisterViewModel viewModel;

  const WeightSelectionScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return RegisterMeasurementStep(
      viewModel: viewModel,
      step: 3,
      title: AppStrings.whatIsYourWeight,
      subtitle: AppStrings.personalizedPlanSubtitle,
      unit: AppStrings.kilogram,
      buttonLabel: AppStrings.done,
      min: RegisterConstants.minimumWeight,
      max: RegisterConstants.maximumWeight,
      valueOf: (state) => state.weight ?? RegisterConstants.defaultWeight,
      updateEvent: (value) => UpdateWeightEvent(weight: value),
      nextStep: RegisterFlowStep.height,
    );
  }
}
