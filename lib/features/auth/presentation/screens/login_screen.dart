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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Assets.authBackGround, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(Assets.authLogo),
                  ),
                  Text(
                    AppStrings.heyThere,
                    style: TextStyles.bodyMedium18.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Text(AppStrings.welcomeBACK, style: TextStyles.bodyRegular20),
                  const LoginWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
