import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';

class RegisterFlowListener extends StatelessWidget {
  final PageController pageController;
  final Widget child;

  const RegisterFlowListener({
    super.key,
    required this.pageController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterViewModel, RegisterState>(
      listenWhen: (previous, current) =>
          previous.navigationRequestId != current.navigationRequestId,
      listener: (context, state) {
        final page = _pageOf(state.navigationTarget);
        if (page == null || !pageController.hasClients) return;

        pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
      child: child,
    );
  }

  int? _pageOf(RegisterFlowStep? step) => step == null ? null : step.index + 1;
}
