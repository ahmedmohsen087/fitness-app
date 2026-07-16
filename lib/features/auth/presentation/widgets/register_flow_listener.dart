import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/values/app_routs_name.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';

class RegisterFlowListener extends StatelessWidget {
  final Widget child;

  const RegisterFlowListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterViewModel, RegisterState>(
      listenWhen: (previous, current) =>
          previous.navigationRequestId != current.navigationRequestId,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        final routeName = _routeName(state.navigationTarget);
        if (routeName == null) return;

        Navigator.pushNamed(
          context,
          routeName,
          arguments: context.read<RegisterViewModel>(),
        );
      },
      child: child,
    );
  }

  String? _routeName(RegisterFlowStep? step) => switch (step) {
    RegisterFlowStep.gender => AppRoutsName.genderSelection,
    RegisterFlowStep.age => AppRoutsName.registerAge,
    RegisterFlowStep.weight => AppRoutsName.registerWeight,
    RegisterFlowStep.height => AppRoutsName.registerHeight,
    RegisterFlowStep.goal => AppRoutsName.registerGoal,
    RegisterFlowStep.activity => AppRoutsName.registerActivity,
    null => null,
  };
}
