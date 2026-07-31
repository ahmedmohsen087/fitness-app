import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';

class FoodDetailsNavigationBar extends StatelessWidget {
  static const _animationDuration = Duration(milliseconds: 260);

  final String mealName;
  final bool showTitle;

  const FoodDetailsNavigationBar({
    super.key,
    required this.mealName,
    required this.showTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeOutCubic,
      color: showTitle
          ? AppColors.lightBlack.withValues(alpha: 0.94)
          : Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Semantics(
                button: true,
                label: AppStrings.back,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.maybePop(context),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Center(
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.orange,
                        child: SvgPicture.asset(
                          Assets.backArrowIcon,
                          width: 14,
                          height: 14,
                          matchTextDirection: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRect(
                  child: AnimatedSlide(
                    duration: _animationDuration,
                    curve: Curves.easeOutCubic,
                    offset: showTitle ? Offset.zero : const Offset(0, 0.55),
                    child: AnimatedOpacity(
                      duration: _animationDuration,
                      curve: Curves.easeOutCubic,
                      opacity: showTitle ? 1 : 0,
                      child: Text(
                        mealName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.authSubtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
