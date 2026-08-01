import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:flutter/material.dart';

class SmartCoachWelcomeWidget extends StatelessWidget {
  final VoidCallback onGetStartedTap;

  const SmartCoachWelcomeWidget({
    super.key,
    required this.onGetStartedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              Assets.botAvatar,
              height: 280,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
        _buildBottomCard(),
      ],
    );
  }

  Widget _buildBottomCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBlack.withAlpha(200),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withAlpha(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.howCanIAssistYouToday,
            textAlign: TextAlign.center,
            style: TextStyles.bodyRegular20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: onGetStartedTap,
              child: Text(
                AppStrings.getStarted,
                style: TextStyles.buttonTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
