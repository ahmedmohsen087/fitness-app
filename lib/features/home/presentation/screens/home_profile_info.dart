import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';

class HomeProfileInfo extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? onProfileTap;

  const HomeProfileInfo({this.name, this.image, super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.hi} ${name ?? ''}',
              style: TextStyles.bodyRegular16,
            ),
            Text(
              AppStrings.letsStartYourDay,
              style: TextStyles.bodyMedium18.copyWith(color: AppColors.white),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(20),
          child: CircleAvatar(
            backgroundColor: AppColors.placeHolder,
            backgroundImage: (image != null && image!.isNotEmpty)
                ? NetworkImage(image!)
                : null,
            child: (image == null || image!.isEmpty)
                ? const Icon(Icons.person, color: AppColors.white)
                : null,
          ),
        ),
      ],
    );
  }
}
