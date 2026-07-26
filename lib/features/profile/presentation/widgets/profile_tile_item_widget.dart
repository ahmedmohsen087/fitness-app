import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileTileItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color textColor;
  final Color iconColor;

  const ProfileTileItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.textColor = AppColors.white,
    this.iconColor = AppColors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: AppColors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(leadingIcon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.orange,
            size: 18,
          ),
    );
  }
}
