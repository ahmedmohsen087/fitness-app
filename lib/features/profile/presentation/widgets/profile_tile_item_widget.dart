import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileTileItem extends StatelessWidget {
  final String leadingIcon;
  final String title;
  final Widget? titleWidget;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color textColor;
  final Color iconColor;
  final double iconWidth;
  final double iconHeight;

  const ProfileTileItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.titleWidget,
    required this.onTap,
    this.trailing,
    this.textColor = AppColors.white,
    this.iconColor = AppColors.orange,
    this.iconWidth = 20,
    this.iconHeight = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: SvgPicture.asset(
          leadingIcon,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          width: iconWidth,
          height: iconHeight,
        ),
        title: titleWidget ??
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.orange,
              size: 14,
            ),
      ),
    );
  }
}
