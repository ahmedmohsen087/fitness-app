import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../widgets/login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.authBackground,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  Assets.appLogo,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.heyThere,
                style: TextStyles.bodyMedium18.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.welcomeBACK,
                style: TextStyles.bodyRegular20.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              const LoginWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
