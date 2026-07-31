import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileTileItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget? titleWidget;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color textColor;
  final Color iconColor;

  const ProfileTileItem({
    super.key,
    required this.leadingIcon,
    this.title = '',
    this.titleWidget,
    required this.onTap,
    this.trailing,
    this.textColor = AppColors.white,
    this.iconColor = AppColors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(leadingIcon, color: iconColor),
      title: titleWidget ??
          Text(
            title,
            style: TextStyles.bodyRegular16.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.orange,
            size: 22,
          ),
    );
  }
}
