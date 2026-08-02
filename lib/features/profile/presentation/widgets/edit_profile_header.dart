import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';

class EditProfileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const EditProfileHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Text(AppStrings.editProfile, style: TextStyles.authTitle),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: _BackButton(onTap: onBack),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppStrings.back,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.orange,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
            size: 12,
          ),
        ),
      ),
    );
  }
}
