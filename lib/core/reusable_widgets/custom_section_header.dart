import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/text_styles.dart';
import '../values/app_strings.dart';

class CustomSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const CustomSectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.labelTextFieldStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onSeeAllTap != null)
          InkWell(
            onTap: onSeeAllTap,
            child: Text(
              AppStrings.seeAll,
              style: TextStyles.textRegular12.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
