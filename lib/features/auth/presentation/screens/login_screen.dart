import 'package:fitness_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/assets.dart';
import 'login_with_google.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            Assets.authBackGround,
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  Assets.authLogo,
                ),
              ),
              Text(AppStrings.heyThere,
              style: TextStyles.bodyMedium18.copyWith(color: AppColors.white),),
              Text(AppStrings.welcomeBACK,
              style: TextStyles.bodyRegular20,),
              ]
          ),
        )
      ],
    );
  }
}