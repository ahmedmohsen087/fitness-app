import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import 'auth_background.dart';
import 'auth_glass_panel.dart';
import 'auth_logo.dart';

class RegisterStepScaffold extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  final Widget child;

  const RegisterStepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(child: AuthLogo()),
              ),
              Positioned(top: 28, left: 16, child: _BackButton()),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepIndicator(step: step),
                      const SizedBox(height: 8),
                      _StepHeading(title: title, subtitle: subtitle),
                      const SizedBox(height: 8),
                      AuthGlassPanel(child: child),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppStrings.back,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.maybePop(context),
        child: const CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.orange,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 12,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;

  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: step / 6,
            strokeWidth: 2,
            color: AppColors.orange,
            backgroundColor: AppColors.white.withValues(alpha: 0.15),
          ),
          Text(AppStrings.registerStep(step), style: TextStyles.authStep),
        ],
      ),
    );
  }
}

class _StepHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StepHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.authHeadline),
            Text(subtitle, style: TextStyles.authSubtitle),
          ],
        ),
      ),
    );
  }
}
