import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../values/app_strings.dart';
import '../values/assets.dart';
import 'custom_network_image.dart';

class CustomDetailHeaderBanner extends StatelessWidget {
  final String image;
  final String title;
  final double height;

  const CustomDetailHeaderBanner({
    super.key,
    required this.image,
    required this.title,
    this.height = 260.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomNetworkImage(imageUrl: image, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.3),
                  AppColors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 16,
            start: 16,
            child: SafeArea(
              child: Semantics(
                button: true,
                label: AppStrings.back,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.maybePop(context),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.orange,
                    child: SvgPicture.asset(
                      Assets.assetsIconsBackArrow,
                      width: 16,
                      height: 16,
                      matchTextDirection: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyles.authTitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
