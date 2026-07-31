import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final VoidCallback onBackPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        const SizedBox(height: 24),
        _buildAvatar(),
        const SizedBox(height: 16),
        _buildName(),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    bool isRtl = false;
    try {
      isRtl = context.locale.languageCode == 'ar';
    } catch (_) {}

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onBackPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRtl
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
        Text(
          AppStrings.profile,
          style: TextStyles.bodyRegular24.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 110,
      height: 110,
      decoration: const BoxDecoration(
        color: AppColors.lightBlack,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: CustomNetworkImage(
          imageUrl: imageUrl.isNotEmpty ? imageUrl : Assets.defaultExerciseImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      userName,
      style: TextStyles.bodyRegular20.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
