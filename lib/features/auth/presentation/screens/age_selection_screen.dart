import 'package:flutter/material.dart';

import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../view_model/register_events.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import '../widgets/register_measurement_step.dart';

class AgeSelectionScreen extends StatelessWidget {
  final RegisterViewModel viewModel;

  const AgeSelectionScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return RegisterMeasurementStep(
      viewModel: viewModel,
      step: 2,
      title: AppStrings.howOldAreYou,
      subtitle: AppStrings.personalizedPlanSubtitle,
      unit: AppStrings.year,
      buttonLabel: AppStrings.next,
      min: RegisterConstants.minimumAge,
      max: RegisterConstants.maximumAge,
      valueOf: (state) => state.age ?? RegisterConstants.defaultAge,
      updateEvent: (value) => UpdateAgeEvent(age: value),
      nextStep: RegisterFlowStep.weight,
    );
  }
}
