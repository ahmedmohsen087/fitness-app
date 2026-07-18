import 'package:flutter/material.dart';

import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../widgets/register_measurement_step.dart';

class HeightSelectionScreen extends StatelessWidget {
  final VoidCallback onBack;

  const HeightSelectionScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return RegisterMeasurementStep(
      onBack: onBack,
      step: 4,
      title: AppStrings.whatIsYourHeight,
      subtitle: AppStrings.personalizedPlanSubtitle,
      unit: AppStrings.centimeter,
      buttonLabel: AppStrings.next,
      min: RegisterConstants.minimumHeight,
      max: RegisterConstants.maximumHeight,
      valueOf: (state) => state.height ?? RegisterConstants.defaultHeight,
      updateEvent: (value) => UpdateHeightEvent(height: value),
      nextStep: RegisterFlowStep.goal,
    );
  }
}
