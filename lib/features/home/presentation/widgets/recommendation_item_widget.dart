import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class RecommendationItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  const RecommendationItemWidget({
    super.key,
    required this.image,
    required this.title,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: title,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(
          width: width ?? 104,
          height: height ?? 104,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: image.trim().isEmpty
                    ? const _RecommendationImagePlaceholder()
                    : Image.network(
                        image,
                        width: width ?? 104,
                        height: height ?? 104,
                        fit: BoxFit.fill,
                        errorBuilder: (_, _, _) =>
                            const _RecommendationImagePlaceholder(),
                      ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlack.withValues(alpha: .80),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.bodyRegular12.copyWith(
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationImagePlaceholder extends StatelessWidget {
  const _RecommendationImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.lightBlack,
      child: Icon(Icons.restaurant_rounded, color: AppColors.lightGray),
    );
  }
}
